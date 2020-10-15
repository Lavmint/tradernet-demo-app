//
//  Optional.swift
//  StockQuotes
//
//  Created by Alexey Averkin on 15.10.2020.
//

import Foundation

extension Optional where Wrapped: Equatable {
    
    mutating func updateIfNotNil(_ newValue: Wrapped?) {
        guard let value = newValue else {
            return
        }
        guard value != self else {
            return
        }
        self = .some(value)
    }
}
