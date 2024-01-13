//
//  USDFormatterTests.swift
//  RefactoringMartinFowlerTests
//
//  Created by Luis David Goyes on 10/01/24.
//

import XCTest
@testable import RefactoringMartinFowler

final class USDFormatterTests: XCTestCase {
    
    private struct Stub {
        struct PositiveAmountInCents {
            static let input = 65000
            static let expectedOutput = "$650.00"
        }
    }

    private var sut: USDFormatter!
    
    override func setUp() {
        super.setUp()
        sut = USDFormatter()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_WHEN_formattingANumber_GIVEN_someDouble_THEN_itShouldReturnTheExpectedFormattedString() throws {
        let result = try sut.format(amountInCents: Stub.PositiveAmountInCents.input)
        XCTAssertEqual(result, Stub.PositiveAmountInCents.expectedOutput)
    }
}
