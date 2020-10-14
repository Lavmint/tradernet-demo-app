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

struct StockQuotesListView: StatefulView {

    var tradenet = Environment(\.provider).wrappedValue.of(TradernetSocketManager.self)
    var state = State<StockQuotesListState>(wrappedValue: Self.createState())
    
    private var _state: StockQuotesListState {
        return state.wrappedValue
    }
    
    static func createState() -> StockQuotesListState {
        return StockQuotesListState()
    }
    
    var body: some View {
        List(_state.stocks, id: \.ticket) { stock in
            ZStack(content: {
                VStack(content: {
                    Text("Company")
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                VStack(content: {
                    Text("daily change")
                    HStack(spacing: 8, content: {
                        Text("last price")
                        Text("(change)")
                    })
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
            })
        }
        .onAppear(perform: {
            tradenet.defaultSocket.connect(timeoutAfter: 10.0, withHandler: nil)
        })
        .onReceive(tradenet.onQuotes) { quotes in
            
        }
    }
    
    
}

struct StockQuotesListState {
    
    var stocks: [StockQuote] = StockQuote.dummy()
    
}

struct StockQuotesListView_Previews: PreviewProvider {
    static var previews: some View {
        StockQuotesListView()
    }
}
