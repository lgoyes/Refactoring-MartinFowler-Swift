//
//  BillPrinterTests.swift
//  RefactoringMartinFowlerTests
//
//  Created by Luis David Goyes Garces on 16/12/23.
//

import XCTest
@testable import RefactoringMartinFowler

fileprivate struct BillPrinterStub {
    static let plays = [
        "hamlet": Play(name: "Hamlet", type: "tragedy"),
        "as-like": Play(name: "As You Like It", type: "comedy"),
        "othello": Play(name: "Othello", type: "tragedy"),
    ]
    static let invoice = Invoice(customer: "hamlet", performances: [
        Performance(playId: "hamlet", audience: 55),
        Performance(playId: "as-like", audience: 35),
        Performance(playId: "othello", audience: 40),
    ])
    static let expectedOutput = """
                                Statement for hamlet
                                   Hamlet: 650,00 US$ (55) seats
                                   As You Like It: 580,00 US$ (35) seats
                                   Othello: 500,00 US$ (40) seats
                                Amount owed is 1730,00 US$
                                You earned 47 credits
                                """
}

final class BillPrinterTests: XCTestCase {

    private var sut: BillPrinter!

    override func setUp() {
        super.setUp()
        sut = BillPrinter(invoice: BillPrinterStub.invoice, plays: BillPrinterStub.plays)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_WHEN_statement_GIVEN_somePlaysAndInvoices_THEN_itShouldReturnSomething() throws {
        let result = try sut.statement()
        let expectedResult = BillPrinterStub.expectedOutput
        XCTAssertEqual(result, expectedResult)
    }
}
