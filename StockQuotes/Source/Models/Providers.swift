//
//  Providers.swift
//  StockQuotes
//
//  Created by Alexey Averkin on 14.10.2020.
//

import Foundation
import TradernetClient

extension TradernetSocketManager: Provider {
    
    public static func create() -> Provider {
        return Self.create(server: .w3, decoder: JSONDecoder())
    }

}
