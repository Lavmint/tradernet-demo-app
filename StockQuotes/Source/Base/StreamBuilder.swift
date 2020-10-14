//
//  StreamBuilder.swift
//  StockQuotes
//
//  Created by Alexey Averkin on 14.10.2020.
//

import Foundation
import SwiftUI
import Combine

struct StreamBuilder<P: Publisher, Content>: View where Content: View {
    
    private var _state: State<Snapshot<P.Output>>
    private var _stream: P
    private var _content: (Snapshot<P.Output>) -> Content
    
    init(stream: P, initialData: P.Output? = nil, _ builder: @escaping (Snapshot<P.Output>) -> Content) {
        let snapshot = Snapshot.withData(connectionState: .none, data: initialData)
        _stream = stream
        _state = State<Snapshot<P.Output>>(wrappedValue: snapshot)
        _content = builder
    }

    var body: some View {
        _content(_state.wrappedValue)
            .onAppear(perform: {
                _state.wrappedValue = Snapshot.waiting()
            })
            .onReceive(_subscription()) { (isStreaming) in
//                print("streaming: \(isStreaming)")
            }
    }
    
    private func _subscription() -> AnyPublisher<Bool, Never> {
        return _stream
            .handleEvents(
                receiveOutput: { data in
                    _state.wrappedValue = Snapshot.withData(connectionState: .active, data: data)
                },
                receiveCompletion: { (completion) in
                    switch completion {
                    case .failure(let error):
                        _state.wrappedValue = Snapshot.withError(connectionState: .done, error: error)
                    case .finished:
                        let data = _state.wrappedValue.data
                        _state.wrappedValue = Snapshot.withData(connectionState: .done, data: data)
                    }
                }
            )
            .map({ value in
                return true
            })
            .catch({ error in
                Just(false)
            })
            .receive(on: OperationQueue.main)
            .eraseToAnyPublisher()
    }
    
}

enum ConnectionState {
    case none, waiting, active, done
}

struct Snapshot<T> {

    let connectionState: ConnectionState
    let data: T?
    let error: Error?
    
    var hasData: Bool {
        return data != nil
    }
    
    var hasError: Bool {
        return error != nil
    }
    
}

extension Snapshot {

    static func nothing() -> Snapshot<T> {
        return Snapshot(connectionState: .none, data: nil, error: nil)
    }

    static func waiting() -> Snapshot<T> {
        return Snapshot(connectionState: .waiting, data: nil, error: nil)
    }

    static func withData(connectionState: ConnectionState, data: T?) -> Snapshot<T> {
        return Snapshot(connectionState: connectionState, data: data, error: nil)
    }

    static func withError(connectionState: ConnectionState, error: Error) -> Snapshot<T> {
        return Snapshot(connectionState: connectionState, data: nil, error: error)
    }
}
