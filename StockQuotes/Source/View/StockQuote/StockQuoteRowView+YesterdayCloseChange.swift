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
        var isUpdating = false
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
                return state.isUpdating ? Color.white : Color.green
            } else if change < 0 {
                return state.isUpdating ? Color.white : Color.red
            } else {
                return Color.black
            }
        }
        
        var rectangleColor: Color {
            if change > 0 {
                return state.isUpdating ? Color.green : Color.clear
            } else if change < 0 {
                return state.isUpdating ? Color.red : Color.clear
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
                    quote.yesterdayCloseChange = change
                    state.yesterdayCloseChange = change
                    state.isUpdating = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        state.isUpdating = false
                    }
                }
        }
        
        var onPriceChangesFromPreviosDay: AnyPublisher<Float, Never> {
            provider.of(TradernetSocketManager.self)
                .onQuote(ticker: quote.ticker)
                .filter({ $0.percentageChangePrice != nil })
                .map({ $0.percentageChangePrice! })
                .removeDuplicates()
                .eraseToAnyPublisher()
        }
        
    }

    
}
