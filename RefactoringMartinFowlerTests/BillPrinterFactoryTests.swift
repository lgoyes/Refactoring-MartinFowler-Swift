//
//  BillPrinterFactoryTests.swift
//  RefactoringMartinFowlerTests
//
//  Created by Luis David Goyes Garces on 27/1/24.
//

import XCTest
@testable import RefactoringMartinFowler

final class BillPrinterFactoryTests: XCTestCase {
    
    enum Stub {
        static let invoice = Invoice(customer: "hamlet", performances: [
            Performance(playId: "hamlet", audience: 55),
            Performance(playId: "as-like", audience: 35),
            Performance(playId: "othello", audience: 40),
        ])
    }
    
    private var sut: BillPrinterFactory!

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_WHEN_create_GIVEN_someInvoice_THEN_itShouldReturnSomeDefaultBillPrinter() {
        sut = BillPrinterFactory(invoice: Stub.invoice)
        let result = sut.create()
        XCTAssert(result is DefaultBillPrinter)
    }
}
