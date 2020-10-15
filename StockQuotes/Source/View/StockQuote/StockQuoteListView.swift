//
//  StockQuotesListView.swift
//  StockQuotes
//
//  Created by Alexey Averkin on 14.10.2020.
//

import Foundation
import SwiftUI
import Combine
import TradernetClient

struct StockQuoteListView: View {

    @Environment(\.provider) var provider
    @State var state = StockQuotesListState()
    
    let fyesterday = NumberFormatter().fraction(min: 2, max: 2).round().percent().sign()
    let fprice = NumberFormatter().fraction(min: 2, max: 2).round()
    let fday = NumberFormatter().fraction(min: 2, max: 2).round().sign()
    var tradenet: TradernetSocketManager {
        return provider.of(TradernetSocketManager.self)
    }
    
    var body: some View {
        List(state.quotes, id: \.ticker) { quote in
            StockQuoteRowView(quote: quote, fyesterday: fyesterday, fprice: fprice, fday: fday)
        }
        .onAppear(perform: {
            tradenet.defaultSocket.connect(timeoutAfter: 10.0, withHandler: nil)
        })
        .onReceive(tradenet.onQuotes.receiveOnMain) { quotes in
            state.update(newQuotes: quotes)
        }
    }
}

struct StockQuotesListState {
    
    private(set) var quotes: [StockQuoteDiff] = []

    mutating func update(newQuotes: [StockQuoteDiff]) {
        
        var result: [StockQuoteDiff] = []
        var updatedTickers = Set<String>()
        
        for new in newQuotes {
            let diff: StockQuoteDiff
            if let old = quotes.first(where: { $0.ticker == new.ticker }) {
                diff = old.merged(with: new)
            } else {
                diff = new
            }
            guard diff.hasValues else {
                continue
            }
            result.append(diff)
            updatedTickers.insert(diff.ticker)
        }
        
        for old in quotes where !updatedTickers.contains(old.ticker) {
            result.append(old)
        }
        
        quotes = result.sorted(by: { $0.ticker < $1.ticker })
    }
}

struct StockQuotesListView_Previews: PreviewProvider {
    static var previews: some View {
        StockQuoteListView()
    }
}
