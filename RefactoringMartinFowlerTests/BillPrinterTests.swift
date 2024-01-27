//
//  BillPrinterTests.swift
//  RefactoringMartinFowlerTests
//
//  Created by Luis David Goyes Garces on 16/12/23.
//

import XCTest
@testable import RefactoringMartinFowler

final class BillPrinterTests: XCTestCase {
    
    enum Stub {
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
                                       Hamlet: $650.00 (55) seats
                                       As You Like It: $580.00 (35) seats
                                       Othello: $500.00 (40) seats
                                    Amount owed is $1,730.00
                                    You earned 47 credits
                                    """
    }

    private var sut: DefaultBillPrinter!
    private var playRepository: PlayResolver!

    override func setUp() {
        super.setUp()
        playRepository = PlayRepository(plays: Stub.plays)
        sut = DefaultBillPrinter(invoice: Stub.invoice, playResolver: playRepository)
    }

    override func tearDown() {
        sut = nil
        playRepository = nil
        super.tearDown()
    }

    func test_WHEN_statement_GIVEN_somePlaysAndInvoices_THEN_itShouldReturnSomething() throws {
        let result = try sut.statement()
        let expectedResult = Stub.expectedOutput
        XCTAssertEqual(result, expectedResult)
    }
}
