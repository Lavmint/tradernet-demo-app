//
//  StockQuoteRowView+YesterdayCloseChange.swift
//  StockQuotes
//
//  Created by Alexey Averkin on 15.10.2020.
//

import Foundation
import SwiftUI
import Combine
import TradernetClient

extension StockQuoteRowView {
    
    struct YesterdayCloseChangeState {
        var yesterdayCloseChange: Float? = nil
        var diff: Float = 0
        var isAnimating = false
    }
    
    struct YesterdayCloseChangeView: View {
        
        @State var state = YesterdayCloseChangeState()
        @Environment(\.provider) var provider
        
        let quote: StockQuote
        let formatter: NumberFormatter

        var change: Float {
            return state.yesterdayCloseChange ?? quote.yesterdayCloseChange ?? Float.nan
        }
        
        var yesterdayCloseChangeString: String {
            guard let str = formatter.string(from: change as NSNumber) else {
                return String(Float.nan)
            }
            return str
        }
        
        var foregroundColor: Color {
            if change > 0 {
                return state.isAnimating ? Color.white : Color.green
            } else if change < 0 {
                return state.isAnimating ? Color.white : Color.red
            } else {
                return Color.black
            }
        }
        
        var rectangleColor: Color {
            if state.diff > 0 {
                return state.isAnimating ? Color.green : Color.clear
            } else if state.diff < 0 {
                return state.isAnimating ? Color.red : Color.clear
            } else {
                return Color.clear
            }
        }
        
        var body: some View {
            Text(yesterdayCloseChangeString)
                .foregroundColor(foregroundColor)
                .background(rectangleColor)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .animation(.easeOut)
                .onReceive(onPriceChangesFromPreviosDay.receiveOnMain) { (change) in
                    if let old = quote.yesterdayCloseChange {
                        state.diff = change - old
                    }
                    quote.yesterdayCloseChange = change
                    state.yesterdayCloseChange = change
                    state.isAnimating = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        state.isAnimating = false
                    }
                }
        }
        
        var onPriceChangesFromPreviosDay: AnyPublisher<Float, Never> {
            provider.of(TradernetSocketManager.self)
                .onQuote(ticker: quote.ticker)
                .compactMap({ $0.percentageChangePrice })
                .removeDuplicates()
                .eraseToAnyPublisher()
        }
        
    }

    
}
