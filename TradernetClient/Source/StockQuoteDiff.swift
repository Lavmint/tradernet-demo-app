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

public extension StockQuoteDiff {
    
    func merged(with diff: StockQuoteDiff) -> StockQuoteDiff {
        var s = self
        s.name.updateIfNotNil(diff.name)
        s.percentageChangePrice.updateIfNotNil(diff.percentageChangePrice)
        s.lastTradePrice.updateIfNotNil(diff.lastTradePrice)
        s.change.updateIfNotNil(diff.change)
        return s
    }
    
    var hasValues: Bool {
        let conditions: [Bool] = [
            name != nil,
            percentageChangePrice != nil,
            lastTradePrice != nil,
            change != nil
        ]
        return conditions.filter({ $0 == true }).count == conditions.count
    }
    
}
