//
//  ChargeCalculatorTests.swift
//  RefactoringMartinFowlerTests
//
//  Created by Luis David Goyes Garces on 27/1/24.
//

import XCTest
@testable import RefactoringMartinFowler

final class ChargeCalculatorTests: XCTestCase {
    
    private enum Stub {
        static let someInvalidPerformance = Performance(playId: "some-invalid-play-id", audience: 1)
        
        enum UnexpectedPlayTypeCase {
            static let somePerformance = Performance(playId: "some-valid-play-id", audience: 29)
            static let somePlay = Play(name: "Hamlet", type: "unexpected")
            static let expectedResult: ChargeCalculator.Error = .unexpectedPlayType
        }
        
        enum TragedyAudienceThresholdCase {
            enum Under {
                static let someValidPerformance = Performance(playId: "some-valid-play-id", audience: 29)
                static let somePlay = Play(name: "Hamlet", type: "tragedy")
                static let expectedResult = 40_000
            }
            enum ExactlyOn {
                static let someValidPerformance = Performance(playId: "some-valid-play-id", audience: 30)
                static let somePlay = Play(name: "Hamlet", type: "tragedy")
                static let expectedResult = 40_000
            }
            enum Over {
                static let someValidPerformance = Performance(playId: "some-valid-play-id", audience: 31)
                static let somePlay = Play(name: "Hamlet", type: "tragedy")
                static let expectedResult = 41_000
            }
            enum LarglyOver {
                static let someValidPerformance = Performance(playId: "some-valid-play-id", audience: 55)
                static let somePlay = Play(name: "Hamlet", type: "tragedy")
                static let expectedResult = 65_000
            }
        }
        
        enum Comedy {
            enum UnderAudienceThresholdCase {
                static let someValidPerformance = Performance(playId: "some-valid-play-id", audience: 19)
                static let somePlay = Play(name: "As You Like It", type: "comedy")
                static let expectedResult = 35700
            }
            enum ExactlyOnAudienceThresholdCase {
                static let someValidPerformance = Performance(playId: "some-valid-play-id", audience: 20)
                static let somePlay = Play(name: "As You Like It", type: "comedy")
                static let expectedResult = 36000
            }
            enum OverAudienceThresholdCase {
                static let someValidPerformance = Performance(playId: "some-valid-play-id", audience: 21)
                static let somePlay = Play(name: "As You Like It", type: "comedy")
                static let expectedResult = 46800
            }
            enum LarglyOverAudienceThresholdCase {
                static let someValidPerformance = Performance(playId: "some-valid-play-id", audience: 55)
                static let somePlay = Play(name: "As You Like It", type: "comedy")
                static let expectedResult = 74000
            }
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
    
    func test_WHEN_calculate_GIVEN_someValidTragedyPerformanceWhoseAudienceIsUnderTheThreshold_THEN_itShouldNOTThrowAnError_itShouldComputeTheExpectedAmountForTheGivenTragedyPerformance() throws {
        playResolver.somePlay = Stub.TragedyAudienceThresholdCase.Under.somePlay
        
        sut = ChargeCalculator(playResolver: playResolver, performance: Stub.TragedyAudienceThresholdCase.Under.someValidPerformance)
        let result = try sut.calculate()
        
        let expectedResult = Stub.TragedyAudienceThresholdCase.Under.expectedResult
        XCTAssertEqual(expectedResult, result)
    }
    
    func test_WHEN_calculate_GIVEN_someValidTragedyPerformanceWhoseAudienceIsExaclyOnThreshold_THEN_itShouldNOTThrowAnError_itShouldComputeTheExpectedAmountForTheGivenTragedyPerformance() throws {
        playResolver.somePlay = Stub.TragedyAudienceThresholdCase.ExactlyOn.somePlay
        
        sut = ChargeCalculator(playResolver: playResolver, performance: Stub.TragedyAudienceThresholdCase.ExactlyOn.someValidPerformance)
        let result = try sut.calculate()
        
        let expectedResult = Stub.TragedyAudienceThresholdCase.ExactlyOn.expectedResult
        XCTAssertEqual(expectedResult, result)
    }
    
    func test_WHEN_calculate_GIVEN_someValidTragedyPerformanceWhoseAudienceIsOverTheThreshold_THEN_itShouldNOTThrowAnError_itShouldComputeTheExpectedAmountForTheGivenTragedyPerformance() throws {
        playResolver.somePlay = Stub.TragedyAudienceThresholdCase.Over.somePlay
        
        sut = ChargeCalculator(playResolver: playResolver, performance: Stub.TragedyAudienceThresholdCase.Over.someValidPerformance)
        let result = try sut.calculate()
        
        let expectedResult = Stub.TragedyAudienceThresholdCase.Over.expectedResult
        XCTAssertEqual(expectedResult, result)
    }
    
    func test_WHEN_calculate_GIVEN_someValidTragedyPerformanceWhoseAudienceIsLarglyOverTheThreshold_THEN_itShouldNOTThrowAnError_itShouldComputeTheExpectedAmountForTheGivenTragedyPerformance() throws {
        playResolver.somePlay = Stub.TragedyAudienceThresholdCase.LarglyOver.somePlay
        
        sut = ChargeCalculator(playResolver: playResolver, performance: Stub.TragedyAudienceThresholdCase.LarglyOver.someValidPerformance)
        let result = try sut.calculate()
        
        let expectedResult = Stub.TragedyAudienceThresholdCase.LarglyOver.expectedResult
        XCTAssertEqual(expectedResult, result)
    }
    
    func test_WHEN_calculate_GIVEN_someValidComedyPerformanceWhoseAudienceIsUnderTheThreshold_THEN_itShouldNOTThrowAnError_itShouldComputeTheExpectedAmountForTheGivenComedyPerformance() throws {
        playResolver.somePlay = Stub.Comedy.UnderAudienceThresholdCase.somePlay
        
        sut = ChargeCalculator(playResolver: playResolver, performance: Stub.Comedy.UnderAudienceThresholdCase.someValidPerformance)
        let result = try sut.calculate()
        
        let expectedResult = Stub.Comedy.UnderAudienceThresholdCase.expectedResult
        XCTAssertEqual(expectedResult, result)
    }
    
    func test_WHEN_calculate_GIVEN_someValidComedyPerformanceWhoseAudienceIsExaclyOnThreshold_THEN_itShouldNOTThrowAnError_itShouldComputeTheExpectedAmountForTheGivenComedyPerformance() throws {
        playResolver.somePlay = Stub.Comedy.ExactlyOnAudienceThresholdCase.somePlay
        
        sut = ChargeCalculator(playResolver: playResolver, performance: Stub.Comedy.ExactlyOnAudienceThresholdCase.someValidPerformance)
        let result = try sut.calculate()
        
        let expectedResult = Stub.Comedy.ExactlyOnAudienceThresholdCase.expectedResult
        XCTAssertEqual(expectedResult, result)
    }
    
    func test_WHEN_calculate_GIVEN_someValidComedyPerformanceWhoseAudienceIsOverTheThreshold_THEN_itShouldNOTThrowAnError_itShouldComputeTheExpectedAmountForTheGivenComedyPerformance() throws {
        playResolver.somePlay = Stub.Comedy.OverAudienceThresholdCase.somePlay
        
        sut = ChargeCalculator(playResolver: playResolver, performance: Stub.Comedy.OverAudienceThresholdCase.someValidPerformance)
        let result = try sut.calculate()
        
        let expectedResult = Stub.Comedy.OverAudienceThresholdCase.expectedResult
        XCTAssertEqual(expectedResult, result)
    }
    
    func test_WHEN_calculate_GIVEN_someValidComedyPerformanceWhoseAudienceIsLarglyOverTheThreshold_THEN_itShouldNOTThrowAnError_itShouldComputeTheExpectedAmountForTheGivenComedyPerformance() throws {
        playResolver.somePlay = Stub.Comedy.LarglyOverAudienceThresholdCase.somePlay
        
        sut = ChargeCalculator(playResolver: playResolver, performance: Stub.Comedy.LarglyOverAudienceThresholdCase.someValidPerformance)
        let result = try sut.calculate()
        
        let expectedResult = Stub.Comedy.LarglyOverAudienceThresholdCase.expectedResult
        XCTAssertEqual(expectedResult, result)
    }

    func test_WHEN_calculate_GIVEN_somePerformanceAssociatedToAnInvalidPlayType_THEN_itShouldThrowAnError() {
        playResolver.somePlay = Stub.UnexpectedPlayTypeCase.somePlay
        
        sut = ChargeCalculator(playResolver: playResolver, performance: Stub.UnexpectedPlayTypeCase.somePerformance)
        
        XCTAssertThrowsError(try sut.calculate()) { error in
            XCTAssertEqual(error as! ChargeCalculator.Error, .unexpectedPlayType)
        }
    }
}
