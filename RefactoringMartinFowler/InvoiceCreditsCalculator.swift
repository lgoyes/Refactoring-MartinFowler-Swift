//
//  InvoiceCreditsCalculator.swift
//  RefactoringMartinFowler
//
//  Created by Luis David Goyes Garces on 9/3/24.
//

import Foundation

class InvoiceCreditsCalculator {
    let invoice: Invoice
    let playResolver: PlayResolver
    init(invoice: Invoice, playResolver: PlayResolver) {
        self.invoice = invoice
        self.playResolver = playResolver
    }
    func calculate() throws -> Int {
        try invoice.performances.reduce(0) { partialResult, performance in
            let performanceCredits = try CreditsCalculator(playResolver: playResolver, performance: performance).calculate()
            return partialResult + performanceCredits
        }
    }
}
