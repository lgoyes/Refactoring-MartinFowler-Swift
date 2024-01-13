//
//  USDFormatter.swift
//  RefactoringMartinFowler
//
//  Created by Luis David Goyes on 10/01/24.
//

import Foundation

protocol USDFormattable {
    func format(amountInCents: Int) throws -> String
}

class USDFormatter: USDFormattable {
    private struct Constant {
        static let centsToUSDConversionFactor = 1.0 / 100.0
    }
    
    enum Error: Swift.Error {
        case possibleNumberOutOfRange
    }
    
    /*
     When you create a new NumberFormatter, the initializer does various setup tasks, such as:
     - Memory Allocation: Allocating memory for the instance and related data structures.
     - Setting Default Values: Initializing default values for properties, such as locale, numberStyle, and others.
     - Locale Configuration: Configuring the formatter based on the default locale. The locale affects how numbers are formatted, including the decimal separator, grouping separator, and other locale-specific settings.
     - Number Style Setup: Setting up default number styles based on the specified or default style.
     */
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()

    func format(amountInCents: Int) throws -> String {
        let amountInUSD = Double(amountInCents) * Constant.centsToUSDConversionFactor
        guard let result = formatter.string(from: NSNumber(value: amountInUSD)) else {
            throw Error.possibleNumberOutOfRange
        }
        return result
    }
}
