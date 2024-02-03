//
//  CreditsCalculatorTests.swift
//  RefactoringMartinFowlerTests
//
//  Created by Luis David Goyes Garces on 3/2/24.
//

import XCTest
@testable import RefactoringMartinFowler

final class CreditsCalculatorTests: XCTestCase {
    
    private enum Stub {
        static let playName = "some play name"
        static let playId = "some-play-id"
        static let someInvalidPerformance = Performance(playId: "some-invalid-play-id", audience: 1)
        enum ThresholdAudience {
            static let above = 31
            static let below = 29
        }
        enum ComedyCase {
            static let somePlay = Play(name: playName, type: "comedy")
            enum BelowThreshold {
                static let performance = Performance(playId: playId, audience: ThresholdAudience.below)
                static let expectedResult = 5
            }
            enum AboveThreshold {
                static let performance = Performance(playId: playId, audience: ThresholdAudience.above)
                static let expectedResult = 7
            }
        }
        enum TragedyCase {
            static let somePlay = Play(name: playName, type: "tragedy")
            enum BelowThreshold {
                static let performance = Performance(playId: playId, audience: ThresholdAudience.below)
                static let expectedResult = 0
            }
            enum AboveThreshold {
                static let performance = Performance(playId: playId, audience: ThresholdAudience.above)
                static let expectedResult = 1
            }
        }
    }
    
    private var sut: CreditsCalculator!
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
        playResolver.someError = PlayRepository.Error.playNotFound
        GIVEN_somePerformance(performance: Stub.someInvalidPerformance)
        
        XCTAssertThrowsError(try sut.calculate()) { error in
            XCTAssertEqual(error as! CreditsCalculator.Error, .invalidPlayIdForPerformance)
        }
    }
    
    func GIVEN_somePerformance(performance: Performance) {
        sut = CreditsCalculator(playResolver: playResolver, performance: performance)
    }
    
    func  test_WHEN_calculate_GIVEN_someValidTragedyPerformanceWhoseAudienceIsBelowThreshold_THEN_itShouldReturnSomeCredits() throws {
        GIVEN_someValidTragedyPlay()
        GIVEN_somePerformance(performance: Stub.TragedyCase.BelowThreshold.performance)
        
        try WHEN_calculate_THEN_itShouldReturnSomeCredits(expectedCredits: Stub.TragedyCase.BelowThreshold.expectedResult)
    }
    
    func GIVEN_someValidTragedyPlay() {
        playResolver.somePlay = Stub.TragedyCase.somePlay
    }
    
    func WHEN_calculate_THEN_itShouldReturnSomeCredits(expectedCredits: Int) throws {
        let result = try sut.calculate()
        XCTAssertEqual(expectedCredits, result)
    }
    
    func  test_WHEN_calculate_GIVEN_someValidTragedyPerformanceWhoseAudienceIsAboveThreshold_THEN_itShouldReturnSomeCredits() throws {
        GIVEN_someValidTragedyPlay()
        GIVEN_somePerformance(performance: Stub.TragedyCase.AboveThreshold.performance)
        
        try WHEN_calculate_THEN_itShouldReturnSomeCredits(expectedCredits: Stub.TragedyCase.AboveThreshold.expectedResult)
    }
    
    func  test_WHEN_calculate_GIVEN_someValidComedyPerformanceWhoseAudienceIsBelowThreshold_THEN_itShouldReturnSomeCredits() throws {
        GIVEN_someValidComedyPlay()
        GIVEN_somePerformance(performance: Stub.ComedyCase.BelowThreshold.performance)
        
        try WHEN_calculate_THEN_itShouldReturnSomeCredits(expectedCredits: Stub.ComedyCase.BelowThreshold.expectedResult)
    }
    
    func GIVEN_someValidComedyPlay() {
        playResolver.somePlay = Stub.ComedyCase.somePlay
    }
    
    func  test_WHEN_calculate_GIVEN_someValidComedyPerformanceWhoseAudienceIsAboveThreshold_THEN_itShouldReturnSomeCredits() throws {
        GIVEN_someValidComedyPlay()
        GIVEN_somePerformance(performance: Stub.ComedyCase.AboveThreshold.performance)
        
        try WHEN_calculate_THEN_itShouldReturnSomeCredits(expectedCredits: Stub.ComedyCase.AboveThreshold.expectedResult)
    }
}
