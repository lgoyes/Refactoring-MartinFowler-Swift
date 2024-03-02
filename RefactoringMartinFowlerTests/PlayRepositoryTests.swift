//
//  PlayRepositoryTests.swift
//  RefactoringMartinFowlerTests
//
//  Created by Luis David Goyes Garces on 20/1/24.
//

import XCTest
@testable import RefactoringMartinFowler

final class PlayRepositoryTests: XCTestCase {
    
    private enum Stub {
        static let plays = [
            "hamlet": Play(name: "Hamlet", type: "tragedy"),
            "as-like": Play(name: "As You Like It", type: "comedy"),
            "othello": Play(name: "Othello", type: "tragedy"),
        ]
        static let somePerformance = Performance(playId: "hamlet", audience: 50)
        static let someInvalidPerformance = Performance(playId: "invalid-play-id", audience: 50)
    }
    
    private var sut: PlayRepository!

    override func setUp() {
        super.setUp()
        sut = PlayRepository(plays: Stub.plays)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_WHEN_getPlay_GIVEN_somePerformance_THEN_itShouldReturnSomePlay() throws {
        let result = try sut.getPlay(for: Stub.somePerformance.playId)
        let expectedResult = Stub.plays["hamlet"]
        XCTAssertEqual(expectedResult, result)
    }
    
    func test_WHEN_getPlay_GIVEN_someInvalidPerformance_THEN_itShouldThrowAnError() {
        XCTAssertThrowsError(try sut.getPlay(for: Stub.someInvalidPerformance.playId)) { error in
            let receivedError = error as! PlayRepository.Error
            let expectedError = PlayRepository.Error.playNotFound
            XCTAssertEqual(expectedError, receivedError)
        }
    }
}
