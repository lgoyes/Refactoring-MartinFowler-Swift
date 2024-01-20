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

enum Error: Swift.Error {
    case unknownType(String)
}

class BillPrinter {
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
            result += "   \(play.name): \( try USDFormatter(amountInCents: thisAmount).format() ) (\(perf.audience)) seats\n"
            totalAmount += thisAmount
        }
        
        result += "Amount owed is \( try USDFormatter(amountInCents: totalAmount).format() )\n"
        result += "You earned \(volumeCredits) credits"
        
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
