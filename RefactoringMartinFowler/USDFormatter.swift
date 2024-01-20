//
//  USDFormatter.swift
//  RefactoringMartinFowler
//
//  Created by Luis David Goyes Garces on 20/1/24.
//

import Foundation

class USDFormatter {
    private enum Constant {
        enum Formatter {
            static let currency = "USD"
            static let locale = "en_US"
        }
        static let centToUSDConversionFactor = 1.0 / 100.0
    }
    
    enum Error: Swift.Error {
        case possibleNumberOutOfRange
    }
    
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = Constant.Formatter.currency
        formatter.locale = Locale(identifier: Constant.Formatter.locale)
        return formatter
    }()
    
    private let amountInCents: Int
    init(amountInCents: Int) {
        self.amountInCents = amountInCents
    }
    
    func format() throws -> String {
        guard let amountInUSD = formatter.string(from: NSNumber(value: Double(amountInCents) * Constant.centToUSDConversionFactor)) else {
            throw Error.possibleNumberOutOfRange
        }
        return amountInUSD
    }
}
