//
//  DefaultBillCalculator.swift
//  RefactoringMartinFowler
//
//  Created by Luis David Goyes Garces on 9/3/24.
//

import Foundation

protocol BillCalculator {
    func calculate() throws -> Bill
}

class DefaultBillCalculator: BillCalculator {
    let invoice: Invoice
    let playResolver: PlayResolver
    init(invoice: Invoice, playResolver: PlayResolver) {
        self.invoice = invoice
        self.playResolver = playResolver
    }
    
    func calculate() throws -> Bill {
        let items = try BillLineItemsExtractor(invoice: invoice, playResolver: playResolver).extract()
        let totalAmountInCents = InvoiceTotalAmountCalculator(items: items).calculateInCents()
        let creditsEarned = try InvoiceCreditsCalculator(invoice: invoice, playResolver: playResolver).calculate()
        return Bill(customer: invoice.customer, items: items, totalAmountInCents: totalAmountInCents, creditsEarned: creditsEarned)
    }
}
