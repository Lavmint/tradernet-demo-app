//
//  StockQuotesApp.swift
//  StockQuotes
//
//  Created by Alexey Averkin on 13.10.2020.
//

import SwiftUI
import TradernetClient

@main
struct StockQuotesApp: App {
    
    var body: some Scene {
        WindowGroup {
            StockQuotesListView()
        }
    }
    
}
