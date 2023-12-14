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
    
    fileprivate func amountFor(_ aPerformance: Performance, in plays: [String: Play]) throws -> Int {
        var result: Int
        switch playFor(aPerformance, in: plays).type {
        case "tragedy":
            result = 40_000
            if aPerformance.audience > 30 {
                result += 1_000 * (aPerformance.audience - 30)
            }
        case "comedy":
            result = 30_000
            if aPerformance.audience > 20 {
                result += 10_000 + 500 * (aPerformance.audience - 20)
            }
            result += 300 * aPerformance.audience
        default:
            throw Error.unknownType(playFor(aPerformance, in: plays).type)
        }
        return result
    }
    
    fileprivate func playFor(_ aPerformance: Performance, in plays: [String: Play]) -> Play {
        plays[aPerformance.playId]!
    }
    
    fileprivate func volumeCreditsFor(_ aPerformance: Performance, _ plays: [String : Play]) -> Int {
        // add volume credits
        var result = max(aPerformance.audience - 30, 0)
        
        // add extra credit for every ten comedy attendees
        if (playFor(aPerformance, in: plays).type == "comedy") {
            result += Int(floor(Double(aPerformance.audience) / 5.0))
        }
        
        return result
    }
    
    func usd(_ aNumber: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: Double(aNumber) / 100.0))!
    }
    
    func totalVolumeCredits(_ invoice: Invoice, _ plays: [String: Play]) -> Int {
        var volumeCredits = 0
        for perf in invoice.performances {
            volumeCredits += volumeCreditsFor(perf, plays)
        }
        return volumeCredits
    }
    
    func statement(invoice: Invoice, plays: [String: Play]) throws -> String {
        
        var totalAmount = 0
        var result = "Statement for \(invoice.customer)\n"
        
        for perf in invoice.performances {
            // print line for this order
            result += "   \(playFor(perf, in: plays).name): \(usd(try amountFor(perf, in: plays))) (\(perf.audience)) seats\n"
            totalAmount += try amountFor(perf, in: plays)
        }
        
        let volumeCredits = totalVolumeCredits(invoice, plays)
        
        result += "Amount owed is \(usd(totalAmount))\n"
        result += "You earned \(volumeCredits) credits"
        
        return result
    }
}
