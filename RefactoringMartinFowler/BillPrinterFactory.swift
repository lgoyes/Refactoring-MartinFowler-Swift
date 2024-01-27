//
//  BillPrinterFactory.swift
//  RefactoringMartinFowler
//
//  Created by Luis David Goyes Garces on 27/1/24.
//

import Foundation

class BillPrinterFactory {
    private let invoice: Invoice
    private static let plays: [String: Play] = [
        "hamlet": Play(name: "Hamlet", type: "tragedy"),
        "as-like": Play(name: "As You Like It", type: "comedy"),
        "othello": Play(name: "Othello", type: "tragedy"),
    ]
    private static let playRepository = PlayRepository(plays: BillPrinterFactory.plays)
    
    init(invoice: Invoice) {
        self.invoice = invoice
    }
    
    func create() -> BillPrinter {
        return DefaultBillPrinter(invoice: invoice, playResolver: BillPrinterFactory.playRepository)
    }
}
