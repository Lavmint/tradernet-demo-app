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
        
        let ticker: String
        let formatter: NumberFormatter
        let initialValue: Float
        
        var lastBidChangeString: String {
            let price = lastBidChange ?? initialValue
            let str = formatter.string(from: price as NSNumber) ?? String(Float.nan)
            return "(\(str))"
        }
        
        var body: some View {
            Text(lastBidChangeString)
                .onReceive(onLastBidChange.receiveOnMain) { (change) in
                    lastBidChange = change
                }
        }
        
        var onLastBidChange: AnyPublisher<Float, Never> {
            provider.of(TradernetSocketManager.self)
                .onQuote(ticker: ticker)
                .filter({ $0.change != nil })
                .map({ $0.change! })
                .removeDuplicates()
                .eraseToAnyPublisher()
        }
        
    }

    
}
