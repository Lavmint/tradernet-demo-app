//
//  StatefulWidget.swift
//  StockQuotes
//
//  Created by Alexey Averkin on 14.10.2020.
//

import Foundation
import SwiftUI

protocol StatefulView: View {
    associatedtype Value
    var state: State<Value> { get set }
    static func createState() -> Value
}
