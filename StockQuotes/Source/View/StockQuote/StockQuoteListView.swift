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
    let fprice = NumberFormatter().fraction(min: 4, max: 4).round()
    let fday = NumberFormatter().fraction(min: 4, max: 4).round().sign()
    var tradenet: TradernetSocketManager {
        return provider.of(TradernetSocketManager.self)
    }
    
    var body: some View {
        List(state.quotes, id: \.ticker) { quote in
            StockQuoteRowView(
                quote: quote,
                fyesterday: fyesterday,
                fprice: fprice,
                fday: fday
            )
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
    
    private(set) var quotes: [StockQuote] = []

    mutating func update(newQuotes: [StockQuoteDiff]) {
        let newSet = Set<StockQuote>(newQuotes.map({ StockQuote(quote: $0) }))
        let oldSet = Set<StockQuote>(quotes)
        let result = oldSet.union(newSet)
        guard result.count > oldSet.count else {
            return
        }
        quotes = result.sorted(by: { $0.ticker < $1.ticker })
    }
}

struct StockQuotesListView_Previews: PreviewProvider {
    static var previews: some View {
        StockQuoteListView()
    }
}
