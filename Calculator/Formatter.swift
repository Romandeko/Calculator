//
//  Formatter.swift
//  Calculator
//
//  Created by Роман Денисенко on 6.10.22.
//

import Foundation
extension Formatter {
    static let scientific: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.positiveFormat = "0.###E0"
        formatter.exponentSymbol = "e"
        return formatter
    }()
}
