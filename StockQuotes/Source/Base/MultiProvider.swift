//
//  MultiProvider.swift
//  StockQuotes
//
//  Created by Alexey Averkin on 14.10.2020.
//

import Foundation
import SwiftUI

public struct MultiProviderKey: EnvironmentKey {
    public static let defaultValue = MultiProvider()
}

public extension EnvironmentValues {
    var provider: MultiProvider {
        get { self[MultiProviderKey.self] }
        set { self[MultiProviderKey.self] = newValue }
    }
}

public protocol Provider {
    static func create() -> Provider
}

public extension Provider {
    static var className: String {
        return String(describing: Self.Type.self)
    }
}

public class MultiProvider {
    
    private var _providers: [Int: Provider] = [:]
    
    public func register<T: Provider>(create: () -> T) {
        let key = T.className.hash
        guard _providers[key] == nil else {
            return
        }
        _providers[key] = create()
    }
    
    public func update<T: Provider>(update: () -> T) {
        _providers.updateValue(update(), forKey: T.className.hash)
    }
    
    public func of<T: Provider>(_ type: T.Type) -> T {
        if let provider = _providers[T.className.hash] {
            return provider as! T
        }
        let provider = T.create()
        _providers[T.className.hash] = provider
        return provider as! T
    }
    
}

public extension View {
    
    func provider<T: Provider>(create: () -> T) -> some View {
        let provider = Environment<MultiProvider>(\.provider)
        provider.wrappedValue.register(create: create)
        return self
    }

    func provider<T: Provider>(update: () -> T) -> some View {
        let provider = Environment<MultiProvider>(\.provider)
        provider.wrappedValue.update(update: update)
        return self
    }
}
