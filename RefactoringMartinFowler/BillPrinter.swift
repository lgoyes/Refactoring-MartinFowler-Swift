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

class BillPrinter {
    enum Error: Swift.Error {
        case unknownType(String)
        case possibleNumberOutOfRange
    }
    
    let invoice: Invoice
    let plays: [String: Play]
    init(invoice: Invoice, plays: [String : Play]) {
        self.invoice = invoice
        self.plays = plays
    }
    
    func statement() throws -> String {
        var totalAmount = 0
        var volumeCredits = 0
        var result = "Statement for \(invoice.customer)\n"
        
        
        
        for perf in invoice.performances {
            // add volume credits
            volumeCredits += getVolumeCreditsFor(performance: perf)
            
            let play = getPlayFor(performance: perf)
            let thisAmount = try computeAmountFor(performance: perf)
            result += "   \(play.name): \(try format(amountInCents: thisAmount)) (\(perf.audience)) seats\n"
            totalAmount += thisAmount
        }
        
        result += "Amount owed is \(try format(amountInCents: totalAmount))\n"
        result += "You earned \(volumeCredits) credits"
        
        return result
    }
    
    func format(amountInCents: Int) throws -> String {
        /*
         When you create a new NumberFormatter, the initializer does various setup tasks, such as:
         - Memory Allocation: Allocating memory for the instance and related data structures.
         - Setting Default Values: Initializing default values for properties, such as locale, numberStyle, and others.
         - Locale Configuration: Configuring the formatter based on the default locale. The locale affects how numbers are formatted, including the decimal separator, grouping separator, and other locale-specific settings.
         - Number Style Setup: Setting up default number styles based on the specified or default style.
         */
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
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
