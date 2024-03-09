//
//  DefaultBillCalculatorTests.swift
//  RefactoringMartinFowlerTests
//
//  Created by Luis David Goyes Garces on 9/3/24.
//

import XCTest
@testable import RefactoringMartinFowler

final class DefaultBillCalculatorTests: XCTestCase {
    
    enum Stub {
        static let customer = "goyes"
        static let plays = [
            "hamlet": Play(name: "Hamlet", type: "tragedy"),
            "as-like": Play(name: "As You Like It", type: "comedy"),
            "othello": Play(name: "Othello", type: "tragedy"),
        ]
        static let invoice = Invoice(customer: customer, performances: [
            Performance(playId: "hamlet", audience: 55),
            Performance(playId: "as-like", audience: 35),
            Performance(playId: "othello", audience: 40),
        ])
    }

    private var sut: DefaultBillCalculator!
    private var playResolver: FakePlayResolver!
    
    override func setUp() {
        super.setUp()
        playResolver = FakePlayResolver()
        sut = DefaultBillCalculator(invoice: Stub.invoice, playResolver: playResolver)
    }

    override func tearDown() {
        sut = nil
        playResolver = nil
        super.tearDown()
    }

    func test_WHEN_calculate_GIVEN_someInvalidPerformance_THEN_itShouldThrowAnError() {
        playResolver.someError = PlayRepository.Error.playNotFound
        
        XCTAssertThrowsError(try sut.calculate()) {
            XCTAssertEqual($0 as! PlayExtractor.Error, .invalidPlayId)
        }
    }
    
    func test_WHEN_calculate_GIVEN_someValidPerformance_THEN_itShouldReturnSomeValidBill() throws {
        GIVEN_someValidPlay()
        
        let actualBill = try WHEN_calculateBill()
        
        THEN_itShouldReturnSomeValidBill(actualBill)
    }
    
    func GIVEN_someValidPlay() {
        playResolver.somePlay = Stub.plays["hamlet"]
    }
    
    func WHEN_calculateBill() throws -> Bill {
        try sut.calculate()
    }
    
    func THEN_itShouldReturnSomeValidBill(_ actualBill: Bill) {
        let expectedBill = Bill(customer: Stub.customer, items: [], totalAmountInCents: 160000, creditsEarned: 40)
        
        XCTAssertEqual(actualBill.customer, expectedBill.customer)
        XCTAssertEqual(actualBill.totalAmountInCents, expectedBill.totalAmountInCents)
        XCTAssertEqual(actualBill.creditsEarned, expectedBill.creditsEarned)
    }
}
