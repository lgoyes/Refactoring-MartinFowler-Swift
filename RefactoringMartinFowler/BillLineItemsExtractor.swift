//
//  BillLineItemsExtractor.swift
//  RefactoringMartinFowler
//
//  Created by Luis David Goyes Garces on 9/3/24.
//

import Foundation

class BillLineItemsExtractor {
    let invoice: Invoice
    let playResolver: PlayResolver
    init(invoice: Invoice, playResolver: PlayResolver) {
        self.invoice = invoice
        self.playResolver = playResolver
    }
    func extract() throws -> [BillLineItem] {
        try invoice.performances.map { try BillLineItemFactory(performance: $0, playResolver: playResolver).create() }
    }
}
