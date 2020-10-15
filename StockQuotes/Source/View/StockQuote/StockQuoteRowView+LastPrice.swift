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
        
        let ticker: String
        let formatter: NumberFormatter
        let initialValue: Float
        
        var lastPriceString: String {
            let price = lastPrice ?? initialValue
            return formatter.string(from: price as NSNumber) ?? String(Float.nan)
        }
        
        var body: some View {
            Text(lastPriceString)
                .onReceive(onLastPrice.receiveOnMain) { (price) in
                    lastPrice = price
                }
        }
        
        var onLastPrice: AnyPublisher<Float, Never> {
            provider.of(TradernetSocketManager.self)
                .onQuote(ticker: ticker)
                .filter({ $0.lastTradePrice != nil })
                .map({ $0.lastTradePrice! })
                .removeDuplicates()
                .eraseToAnyPublisher()
        }
        
    }
    
}
