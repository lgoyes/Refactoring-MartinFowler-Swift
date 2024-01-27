//
//  ChargeCalculatorTests.swift
//  RefactoringMartinFowlerTests
//
//  Created by Luis David Goyes Garces on 27/1/24.
//

import XCTest
@testable import RefactoringMartinFowler

class FakePlayResolver: PlayResolver {
    var receivedPerformance: Performance!
    var getPlayCalled = false
    var someError: ChargeCalculator.Error?
    var somePlay: Play!
    
    func getPlay(for performance: Performance) throws -> Play {
        getPlayCalled = true
        receivedPerformance = performance
        if let someError {
            throw someError
        }
        return somePlay
    }
}

final class ChargeCalculatorTests: XCTestCase {
    
    private enum Stub {
        static let someInvalidPerformance = Performance(playId: "some-invalid-play-id", audience: 1)
        
        enum TragedyCase {
            static let someValidPerformance = Performance(playId: "some-valid-play-id", audience: 55)
            static let somePlay = Play(name: "Hamlet", type: "tragedy")
            static let expectedResult = 650
        }
        
        enum ComedyCase {
            static let someValidPerformance = Performance(playId: "some-valid-play-id", audience: 55)
            static let somePlay = Play(name: "As You Like It", type: "comedy")
            static let expectedResult = 580
        }
    }
    
    private var sut: ChargeCalculator!
    private var playResolver: FakePlayResolver!

    override func setUp() {
        super.setUp()
        playResolver = FakePlayResolver()
    }

    override func tearDown() {
        sut = nil
        playResolver = nil
        super.tearDown()
    }
    
    func test_WHEN_calculate_GIVEN_someInvalidPerformanceWhoseIdIsNotIncludedInTheSetOfAvailablePlays_THEN_itShouldThrowAnError() {
        playResolver.someError = ChargeCalculator.Error.invalidPlayIdForPerformance
        
        sut = ChargeCalculator(playResolver: playResolver, performance: Stub.someInvalidPerformance)
        XCTAssertThrowsError(try sut.calculate()) { error in
            XCTAssertEqual(error as! ChargeCalculator.Error, .invalidPlayIdForPerformance)
        }
    }
    
    func test_WHEN_calculate_GIVEN_someValidTragedyPerformance_THEN_itShouldNOTThrowAnError_itShouldComputeTheExpectedAmountForTheTragedyPerformance() throws {
        playResolver.somePlay = Stub.TragedyCase.somePlay
        
        sut = ChargeCalculator(playResolver: playResolver, performance: Stub.TragedyCase.someValidPerformance)
        let result = try sut.calculate()
        
        let expectedResult = Stub.TragedyCase.expectedResult
        XCTAssertEqual(expectedResult, result)
    }
    
    func test_WHEN_calculate_GIVEN_someValidComedyPerformance_THEN_itShouldNOTThrowAnError_itShouldComputeTheExpectedAmountForTheComedyPerformance() throws {
        playResolver.somePlay = Stub.ComedyCase.somePlay
        
        sut = ChargeCalculator(playResolver: playResolver, performance: Stub.ComedyCase.someValidPerformance)
        let result = try sut.calculate()
        
        let expectedResult = Stub.ComedyCase.expectedResult
        XCTAssertEqual(expectedResult, result)
    }
}
