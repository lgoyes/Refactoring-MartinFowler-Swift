//
//  BillPrinterTests.swift
//  Refactoring-MartinFowler-SwiftTests
//
//  Created by Luis David Goyes on 12/12/23.
//

import XCTest
@testable import Refactoring_MartinFowler_Swift

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
                                   Hamlet: US$ 650,00 (55) seats
                                   As You Like It: US$ 580,00 (35) seats
                                   Othello: US$ 500,00 (40) seats
                                Amount owed is US$ 1.730,00
                                You earned 47 credits
                                """
}

final class BillPrinterTests: XCTestCase {
    
    private var sut: BillPrinter!
    
    override func setUp() {
        super.setUp()
        sut = BillPrinter()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_WHEN_statement_GIVEN_somePlaysAndInvoices_THEN_itShouldReturnSomething() throws {
        let result = try sut.statement(invoice: BillPrinterStub.invoice, plays: BillPrinterStub.plays)
        XCTAssertEqual(result, BillPrinterStub.expectedOutput)
    }
}
