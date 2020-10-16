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

    let quote: StockQuote
    let fyesterday: NumberFormatter
    let fprice: NumberFormatter
    let fday: NumberFormatter
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(quote.ticker)
                    .font(.body)
                Text(quote.name ?? "")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            Spacer(minLength: 16)
            VStack(alignment: .trailing, spacing: 8) {
                YesterdayCloseChangeView(quote: quote, formatter: fyesterday)
                    .font(.body)
                HStack(spacing: 8, content: {
                    LastPriceView(quote: quote, formatter: fprice)
                        .font(.footnote)
                    LastBidChangeView(quote: quote, formatter: fday)
                        .font(.footnote)
                })
            }
        }
    }
}
