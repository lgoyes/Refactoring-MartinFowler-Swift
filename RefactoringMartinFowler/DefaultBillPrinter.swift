//
//  DefaultBillPrinter.swift
//  RefactoringMartinFowler
//
//  Created by Luis David Goyes Garces on 16/12/23.
//

import Foundation

struct Play: Equatable {
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

protocol BillPrinter {
    func statement() throws -> String
}

class DefaultBillPrinter: BillPrinter {
    let invoice: Invoice
    let playResolver: PlayResolver

    init(invoice: Invoice, playResolver: PlayResolver) {
        self.invoice = invoice
        self.playResolver = playResolver
    }
    
    func statement() throws -> String {
        var totalAmount = 0
        var volumeCredits = 0
        var result = "Statement for \(invoice.customer)\n"
        
        for performance in invoice.performances {
            volumeCredits += try getVolumeCreditsFor(performance: performance)
            
            let play = try playResolver.getPlay(for: performance)
            let thisAmount = try ChargeCalculator(playResolver: playResolver, performance: performance).calculate()
            result += "   \(play.name): \( try USDFormatter(amountInCents: thisAmount).format() ) (\(performance.audience)) seats\n"
            totalAmount += thisAmount
        }
        
        result += "Amount owed is \( try USDFormatter(amountInCents: totalAmount).format() )\n"
        result += "You earned \(volumeCredits) credits"
        
        return result
    }
    
    func getVolumeCreditsFor(performance: Performance) throws -> Int {
        var volumeCredits = max(performance.audience - 30, 0)
        let play = try playResolver.getPlay(for: performance)
        if (play.type == "comedy") {
            volumeCredits += Int(floor(Double(performance.audience) / 5.0))
        }
        return volumeCredits
    }
}
