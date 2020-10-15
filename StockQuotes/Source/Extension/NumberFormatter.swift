//
//  NumberFormatter.swift
//  StockQuotes
//
//  Created by Alexey Averkin on 15.10.2020.
//

import Foundation

extension NumberFormatter {
    
    func round() -> NumberFormatter {
        roundingMode = .halfUp
        return self
    }
    
    func fraction(min: Int, max: Int) -> NumberFormatter {
        minimumFractionDigits = min
        maximumFractionDigits = max
        return self
    }
    
    func sign() -> NumberFormatter {
        positivePrefix = "+"
        negativePrefix = "-"
        return self
    }
    
    func percent() -> NumberFormatter {
        negativeSuffix = "%"
        positiveSuffix = "%"
        return self
    }
    
}
