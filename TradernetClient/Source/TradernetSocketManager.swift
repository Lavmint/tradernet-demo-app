//
//  TradernetSocketManager.swift
//  TradernetClient
//
//  Created by Alexey Averkin on 14.10.2020.
//

import Foundation
import SocketIO
import Combine

open class TradernetSocketManager: SocketManager {
    
    public let onConnect = PassthroughSubject<Void, Never>()
    public let onDisconnect = PassthroughSubject<Void, Never>()
    public let onError = PassthroughSubject<Void, Never>()
    public var onQuotes: AnyPublisher<[StockQuoteDiff], Never> {
        _onQuotes
            .compactMap({ $0[0] as? [String: [Any]] })
            .compactMap({ $0["q"] })
            .tryMap({ try JSONSerialization.data(withJSONObject: $0, options: []) })
            .decode(type: [StockQuoteDiff].self, decoder: _decoder)
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    private let _onQuotes = PassthroughSubject<[Any], Never>()
    private var _decoder: JSONDecoder = JSONDecoder()

    public override init(socketURL: URL, config: SocketIOClientConfiguration = []) {
        super.init(socketURL: socketURL, config: config)
        
        reconnects = true
        reconnectWait = 10
        reconnectWaitMax = 60
        
        defaultSocket.on(clientEvent: .connect) { [weak self] (_, _) in
            self?._onConnect()
        }
        defaultSocket.on(clientEvent: .disconnect) { [weak self] (_, _) in
            self?.onDisconnect.send()
        }
        defaultSocket.on(clientEvent: .error) { [weak self] (_, _) in
            self?.onError.send()
        }
        defaultSocket.on("q") { [weak self] (data, ack) in
            self?._onQuotes.send(data)
        }
    }
    
    private func _onConnect() {
        let stocks = """
        RSTI,GAZP,MRKZ,RUAL,HYDR,MRKS,SBER,FEES,TGKA,VTBR,ANH.US,VICL.US,BURG.
        US,NBL.US,YETI.US,WSFS.US,NIO.US,DXC.US,MIC.US,HSBC.US,EXPN.EU,GSK.EU,SH
        P.EU,MAN.EU,DB1.EU,MUV2.EU,TATE.EU,KGF.EU,MGGT.EU,SGGD.EU
        """.split(separator: ",")
        defaultSocket.emit("sup_updateSecurities2", stocks)
        onConnect.send()
    }
    
}

extension TradernetSocketManager {
    
    public enum Server: String {
        case w3 = "https://ws3.tradernet.ru"
    }
    
    open class func create(server: Server, decoder: JSONDecoder) -> TradernetSocketManager {
        let url = URL(string: server.rawValue)!
        let manager = TradernetSocketManager(socketURL: url, config: [.log(false), .compress])
        manager._decoder = decoder
        return manager
    }
    
    public static let shared = TradernetSocketManager.create(server: .w3, decoder: JSONDecoder())
}
