//
//  Publisher.swift
//  StockQuotes
//
//  Created by Alexey Averkin on 15.10.2020.
//

import Foundation
import Combine

extension Publisher {
    
    var receiveOnMain: Publishers.ReceiveOn<Self, OperationQueue> {
        return receive(on: OperationQueue.main)
    }
}
