//
//  Stock.swift
//  StockQuotes
//
//  Created by Alexey Averkin on 13.10.2020.
//

import Foundation
import TradernetClient

class StockQuote {
     
    private(set) var _quote: StockQuoteDiff
    
    init(quote: StockQuoteDiff) {
        _quote = quote
    }
    
    func update(with quote: StockQuoteDiff) {
        _quote = _quote.merged(with: quote)
    }
    
}

extension StockQuote: Identifiable {
    
    var id: String {
        return _quote.ticker
    }
    
}
