//
//  StockQuoteRowView+LastBidChange.swift
//  StockQuotes
//
//  Created by Alexey Averkin on 15.10.2020.
//

import Foundation
import Combine
import SwiftUI
import TradernetClient

extension StockQuoteRowView {
    
    struct LastBidChangeView: View {
        
        @State var lastBidChange: Float? = nil
        @Environment(\.provider) var provider
        
        let quote: StockQuote
        let formatter: NumberFormatter
        
        var change: Float {
            return lastBidChange ?? quote.lastBidChange ?? Float.nan
        }
        
        var lastBidChangeString: String {
            guard let str = formatter.string(from: change as NSNumber) else {
                return String(Float.nan)
            }
            return "(\(str))"
        }
        
        var body: some View {
            Text(lastBidChangeString)
                .animation(.easeOut)
                .onReceive(onLastBidChange.receiveOnMain) { (change) in
                    quote.lastBidChange = change
                    lastBidChange = change
                }
        }
        
        var onLastBidChange: AnyPublisher<Float, Never> {
            provider.of(TradernetSocketManager.self)
                .onQuote(ticker: quote.ticker)
                .compactMap({ $0.change })
                .removeDuplicates()
                .eraseToAnyPublisher()
        }
        
    }

    
}
