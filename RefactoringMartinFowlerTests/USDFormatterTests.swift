//
//  USDFormatterTests.swift
//  RefactoringMartinFowlerTests
//
//  Created by Luis David Goyes Garces on 20/1/24.
//

import XCTest
@testable import RefactoringMartinFowler

final class USDFormatterTests: XCTestCase {
    
    private var sut: USDFormatter!
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_WHEN_format_GIVEN_someDecimalNumber_THEN_itShouldReturnTheExpectedValue() throws {
        let amountInCents = 100
        sut = USDFormatter(amountInCents: amountInCents)
        let result = try sut.format()
        let expectedResult = "$1.00"
        XCTAssertEqual(expectedResult, result)
    }
}
