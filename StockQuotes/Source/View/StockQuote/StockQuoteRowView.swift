//
//  StockQuoteRow.swift
//  StockQuotes
//
//  Created by Alexey Averkin on 14.10.2020.
//

import Foundation
import Combine
import SwiftUI
import TradernetClient

struct StockQuoteRowView: View {

    @Environment(\.provider) var provider

    let quote: StockQuoteDiff
    let fyesterday: NumberFormatter
    let fprice: NumberFormatter
    let fday: NumberFormatter
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(quote.ticker)
                    .font(.body)
                Text(quote.name!)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 8) {
                YesterdayCloseChangeView(
                    ticker: quote.ticker,
                    formatter: fyesterday,
                    initialValue: quote.percentageChangePrice!
                )
                .font(.body)
                HStack(spacing: 8, content: {
                    LastPriceView(
                        ticker: quote.ticker,
                        formatter: fprice,
                        initialValue: quote.lastTradePrice!
                    )
                    .font(.footnote)
                    LastBidChangeView(
                        ticker: quote.ticker,
                        formatter: fday,
                        initialValue: quote.change!
                    )
                    .font(.footnote)
                })
            }
        }
    }
}
