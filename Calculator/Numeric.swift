//
//  Numeric.swift
//  Calculator
//
//  Created by Роман Денисенко on 6.10.22.
//

import Foundation
extension Numeric {
    var scientificFormatted: String {
        return Formatter.scientific.string(for: self) ?? ""
    }
}
