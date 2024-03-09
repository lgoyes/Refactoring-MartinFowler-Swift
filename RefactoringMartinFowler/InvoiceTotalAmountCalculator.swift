//
//  InvoiceTotalAmountCalculator.swift
//  RefactoringMartinFowler
//
//  Created by Luis David Goyes Garces on 9/3/24.
//

import Foundation

class InvoiceTotalAmountCalculator {
    let items: [BillLineItem]
    init(items: [BillLineItem]) {
        self.items = items
    }
    func calculateInCents() -> Int {
        items.reduce(0) { partialResult, item in
            return partialResult + item.amountInCents
        }
    }
}
