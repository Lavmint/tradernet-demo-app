//
//  Stock.swift
//  StockQuotes
//
//  Created by Alexey Averkin on 13.10.2020.
//

import Foundation
import TradernetClient

class StockQuote {
    
    let ticket: String
    var name: String = ""
    var percentageChangePrice: Float = 0.0
    var lastTradePrice: Float = 0.0
    var change: Float = 0.0
    
    init(ticket: String) {
        self.ticket = ticket
    }
}

extension StockQuote {
    
    
    static func dummy() -> [StockQuote] {
        let fees = StockQuote(ticket: "FEES")
        fees.percentageChangePrice = 3.37
        fees.lastTradePrice = 0.21076
        fees.change = 0.000688
        fees.name = "МСХ | ФСК УЭС ао"
        
        let gazp = StockQuote(ticket: "GAZP")
        gazp.name = "МСХ | ГАЗПРОМ ао"
        gazp.percentageChangePrice = 3.37
        gazp.lastTradePrice = 0.21076
        gazp.change = 0.000688
        
        let hydr = StockQuote(ticket: "HYDR")
        hydr.name = "МСХ | РусГидро"
        hydr.percentageChangePrice = 3.37
        hydr.lastTradePrice = 0.21076
        hydr.change = 0.000688
        
        return [fees, gazp, hydr]
    }
    
}

class StockQuoteUpdater {
    
    
    func update(quote: StockQuote, with diff: StockQuoteDiff) {
        quote.percentageChangePrice = diff.percentageChangePrice ?? quote.percentageChangePrice
        quote.name = diff.name ?? quote.name
        quote.lastTradePrice = diff.lastTradePrice ?? quote.lastTradePrice
        quote.change = diff.change ?? quote.change
    }

}
