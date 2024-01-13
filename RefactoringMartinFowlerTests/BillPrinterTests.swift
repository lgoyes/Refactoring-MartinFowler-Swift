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
                                   Hamlet: $650.00 (55) seats
                                   As You Like It: $580.00 (35) seats
                                   Othello: $500.00 (40) seats
                                Amount owed is $1,730.00
                                You earned 47 credits
                                """
    static let expectedOutputHTML = """
                                <h1>Statement for hamlet</h1>
                                <table>
                                <tr><th>Play</th><th>Seats</th><th>Cost</th></tr>
                                   <tr><td>Hamlet</td><td>55</td><td>$650.00</td></tr>
                                   <tr><td>As You Like It</td><td>35</td><td>$580.00</td></tr>
                                   <tr><td>Othello</td><td>40</td><td>$500.00</td></tr>
                                </table>
                                <p>Amount owed is <em>$1,730.00</em></p>
                                <p>You earned <em>47</em> credits</p>
                                """
}

final class BillPrinterTests: XCTestCase {

    private var sut: BillPrinter!

    override func setUp() {
        super.setUp()
        sut = BillPrinter(invoice: BillPrinterStub.invoice, playRepository: DefaultPlayRepository(plays: BillPrinterStub.plays))
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
    
    func test_WHEN_statementHTML_GIVEN_somePlaysAndInvoices_THEN_itShouldReturnSomething() throws {
        let result = try sut.statementHTML()
        let expectedResult = BillPrinterStub.expectedOutputHTML
        XCTAssertEqual(result, expectedResult)
    }
    
    func testPerformace_WHEN_statement() {
        self.measure {
            for _ in 0..<1000 {
                _ = try! sut.statement()
            }
        }
    }
}
