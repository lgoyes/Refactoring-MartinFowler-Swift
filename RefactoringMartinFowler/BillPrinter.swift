//
//  BillPrinter.swift
//  RefactoringMartinFowler
//
//  Created by Luis David Goyes Garces on 16/12/23.
//

import Foundation

struct Play {
    let name: String
    let type: String
}

struct Performance {
    let playId: String
    let audience: Int
}

struct Invoice {
    let customer: String
    let performances: [Performance]
}

class USDFormatterFactory {
    /*
     When you create a new NumberFormatter, the initializer does various setup tasks, such as:
     - Memory Allocation: Allocating memory for the instance and related data structures.
     - Setting Default Values: Initializing default values for properties, such as locale, numberStyle, and others.
     - Locale Configuration: Configuring the formatter based on the default locale. The locale affects how numbers are formatted, including the decimal separator, grouping separator, and other locale-specific settings.
     - Number Style Setup: Setting up default number styles based on the specified or default style.
     */
    
    static func create() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter
    }
}

class BillPrinter {
    enum Error: Swift.Error {
        case unknownType(String)
        case possibleNumberOutOfRange
    }
    
    let invoice: Invoice
    let plays: [String: Play]
    let formatter = USDFormatterFactory.create()
    
    init(invoice: Invoice, plays: [String : Play]) {
        self.invoice = invoice
        self.plays = plays
    }
    
    func statement() throws -> String {
        var result = "Statement for \(invoice.customer)\n"
        for perf in invoice.performances {
            let play = getPlayFor(performance: perf)
            let thisAmount = try computeAmountFor(performance: perf)
            result += "   \(play.name): \(try format(amountInCents: thisAmount)) (\(perf.audience)) seats\n"
        }
        
        let totalAmount = try computeTotalAmount()
        result += "Amount owed is \(try format(amountInCents: totalAmount))\n"
        result += "You earned \(computeTotalVolumeCredits()) credits"
        
        return result
    }
    
    func computeTotalAmount() throws -> Int {
        var totalAmount = 0
        for perf in invoice.performances {
            let thisAmount = try computeAmountFor(performance: perf)
            totalAmount += thisAmount
        }
        return totalAmount
    }
    
    func computeTotalVolumeCredits() -> Int {
        var volumeCredits = 0
        for perf in invoice.performances {
            volumeCredits += getVolumeCreditsFor(performance: perf)
        }
        return volumeCredits
    }
    
    func format(amountInCents: Int) throws -> String {
        let amountInUSD = Double(amountInCents) / 100.0
        guard let result = formatter.string(from: NSNumber(value: amountInUSD)) else {
            throw Error.possibleNumberOutOfRange
        }
        return result
    }
    
    func getVolumeCreditsFor(performance: Performance) -> Int {
        var volumeCredits = max(performance.audience - 30, 0)
        let play = getPlayFor(performance: performance)
        if (play.type == "comedy") {
            volumeCredits += Int(floor(Double(performance.audience) / 5.0))
        }
        return volumeCredits
    }
    
    func getPlayFor(performance: Performance) -> Play {
        plays[performance.playId]!
    }
    
    func computeAmountFor(performance: Performance) throws -> Int {
        var charge = 0
        
        switch getPlayFor(performance: performance).type {
        case "tragedy":
            charge = 40_000
            if performance.audience > 30 {
                charge += 1_000 * (performance.audience - 30)
            }
        case "comedy":
            charge = 30_000
            if performance.audience > 20 {
                charge += 10_000 + 500 * (performance.audience - 20)
            }
            charge += 300 * performance.audience
        default:
            throw Error.unknownType(getPlayFor(performance: performance).type)
        }
        
        return charge
    }
}
