//
//  StockQuoteRowView+LastPrice.swift
//  StockQuotes
//
//  Created by Alexey Averkin on 15.10.2020.
//

import Foundation
import SwiftUI
import Combine
import TradernetClient

extension StockQuoteRowView {
    
    struct LastPriceView: View {
        
        @State var lastPrice: Float? = nil
        @Environment(\.provider) var provider
        
        let quote: StockQuote
        let formatter: NumberFormatter
        
        var price: Float {
            return lastPrice ?? quote.lastPrice ?? Float.nan
        }
        
        var lastPriceString: String {
            guard let str = formatter.string(from: price as NSNumber) else {
                return String(Float.nan)
            }
            return str
        }
        
        var body: some View {
            Text(lastPriceString)
                .animation(.easeOut)
                .onReceive(onLastPrice.receiveOnMain) { (price) in
                    quote.lastPrice = price
                    lastPrice = price
                }
        }
        
        var onLastPrice: AnyPublisher<Float, Never> {
            provider.of(TradernetSocketManager.self)
                .onQuote(ticker: quote.ticker)
                .compactMap({ $0.lastTradePrice })
                .removeDuplicates()
                .eraseToAnyPublisher()
        }
        
    }
    
}
