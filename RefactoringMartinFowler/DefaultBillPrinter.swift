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

struct Bill {
    let customer: String
    let items: [BillLineItem]
    let totalAmountInCents: Int
    let creditsEarned: Int
}

struct BillLineItem {
    let playName: String
    let amountInCents: Int
    let audience: Int
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
        let bill = try createBill()
        return try renderPlainText(bill)
    }
    
    func createBill() throws -> Bill {
        let items = try invoice.performances.map {
            let play = try playResolver.getPlay(for: $0.playId)
            let performanceAmount = try ChargeCalculator(playResolver: playResolver, performance: $0).calculate()
            return BillLineItem(playName: play.name, amountInCents: performanceAmount, audience: $0.audience)
        }
        let totalAmountInCents = items.reduce(0) { partialResult, item in
            return partialResult + item.amountInCents
        }
        let creditsEarned = try invoice.performances.reduce(0) { partialResult, performance in
            let performanceCredits = try CreditsCalculator(playResolver: playResolver, performance: performance).calculate()
            return partialResult + performanceCredits
        }
        return Bill(customer: invoice.customer, items: items, totalAmountInCents: totalAmountInCents, creditsEarned: creditsEarned)
    }
    
    func renderPlainText(_ bill: Bill) throws -> String {
        var result = "Statement for \(bill.customer)\n"
        for item in bill.items {
            result += "   \(item.playName): \( try USDFormatter(amountInCents: item.amountInCents).format() ) (\(item.audience)) seats\n"
        }
        result += "Amount owed is \( try USDFormatter(amountInCents: bill.totalAmountInCents).format() )\n"
        result += "You earned \(bill.creditsEarned) credits"
        
        return result
    }
}
