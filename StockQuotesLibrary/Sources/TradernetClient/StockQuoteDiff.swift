//
//  StockQuote.swift
//  TradernetClient
//
//  Created by Alexey Averkin on 13.10.2020.
//

import Foundation

public struct StockQuoteDiff: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case ticker = "c"
        case percentageChangePrice = "pcp"
        case name = "name"
        case lastTradePrice = "ltp"
        case change = "chg"
    }
    
    /// Тикер
    public private(set) var ticker: String
    
    /// Название бумаги
    public private(set) var name: String?
    
    /// Изменение в процентах относительно цены закрытия предыдущей торговой сессии
    public private(set) var percentageChangePrice: Float?
    
    /// Цена последней сделки
    public private(set) var lastTradePrice: Float?
    
    /// Изменение цены последней сделки в пунктах относительно цены закрытия предыдущей торговой сессии
    public private(set) var change: Float?

}
