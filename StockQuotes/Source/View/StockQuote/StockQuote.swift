//
//  Stock.swift
//  StockQuotes
//
//  Created by Alexey Averkin on 13.10.2020.
//

import Foundation
import TradernetClient

class StockQuote {
     
    let ticker: String
    var name: String?
    var yesterdayCloseChange: Float?
    var lastPrice: Float?
    var lastBidChange: Float?
    
    init(quote: StockQuoteDiff) {
        ticker = quote.ticker
        name = quote.name
        yesterdayCloseChange = quote.percentageChangePrice
        lastPrice = quote.lastTradePrice
        lastBidChange = quote.change
    }
}

extension StockQuote: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(ticker)
    }
    
    static func == (lhs: StockQuote, rhs: StockQuote) -> Bool {
        return lhs.ticker == rhs.ticker
    }
    
}
