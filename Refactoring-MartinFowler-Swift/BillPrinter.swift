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
    
    fileprivate func amountFor(_ play: Play, _ perf: Performance) throws -> Int {
        var result: Int
        switch play.type {
        case "tragedy":
            result = 40_000
            if perf.audience > 30 {
                result += 1_000 * (perf.audience - 30)
            }
        case "comedy":
            result = 30_000
            if perf.audience > 20 {
                result += 10_000 + 500 * (perf.audience - 20)
            }
            result += 300 * perf.audience
        default:
            throw Error.unknownType(play.type)
        }
        return result
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
            let thisAmount = try amountFor(play, perf)
            
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
