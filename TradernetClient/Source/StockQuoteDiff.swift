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
    public let ticker: String
    
    /// Название бумаги
    public let name: String?
    
    /// Изменение в процентах относительно цены закрытия предыдущей торговой сессии
    public let percentageChangePrice: Float?
    
    /// Цена последней сделки
    public let lastTradePrice: Float?
    
    /// Изменение цены последней сделки в пунктах относительно цены закрытия предыдущей торговой сессии
    public let change: Float?
}
