//
//  BillPrinter.swift
//  
//
//  Created by Luis David Goyes on 12/12/23.
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

struct BillPrinter {
    enum Error: Swift.Error {
        case unknownType(String)
    }
    
    fileprivate func amountFor(_ play: Play, _ thisAmount: inout Int, _ perf: Performance) throws {
        switch play.type {
        case "tragedy":
            thisAmount = 40_000
            if perf.audience > 30 {
                thisAmount += 1_000 * (perf.audience - 30)
            }
        case "comedy":
            thisAmount = 30_000
            if perf.audience > 20 {
                thisAmount += 10_000 + 500 * (perf.audience - 20)
            }
            thisAmount += 300 * perf.audience
        default:
            throw Error.unknownType(play.type)
        }
    }
    
    func statement(invoice: Invoice, plays: [String: Play]) throws -> String {
        var totalAmount = 0
        var volumeCredits = 0
        var result = "Statement for \(invoice.customer)\n"
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        
        for perf in invoice.performances {
            let play = plays[perf.playId]!
            var thisAmount = 0
            
            try amountFor(play, &thisAmount, perf)
            
            // add volume credits
            volumeCredits += max(perf.audience - 30, 0)
            
            // add extra credit for every ten comedy attendees
            if (play.type == "comedy") {
                volumeCredits += Int(floor(Double(perf.audience) / 5.0))
            }
            
            // print line for this order
            result += "   \(play.name): \(formatter.string(from: NSNumber(value: totalAmount / 100))!) (\(perf.audience)) seats\n"
            totalAmount += thisAmount
        }
        
        result += "Amount owed is \(formatter.string(from: NSNumber(value: totalAmount / 100))!)\n"
        result += "You earned \(volumeCredits) credits"
        
        return result
    }
}
