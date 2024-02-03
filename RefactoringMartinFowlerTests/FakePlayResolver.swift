//
//  FakePlayResolver.swift
//  RefactoringMartinFowlerTests
//
//  Created by Luis David Goyes Garces on 3/2/24.
//

import Foundation
@testable import RefactoringMartinFowler

class FakePlayResolver: PlayResolver {
    var receivedPerformance: Performance!
    var getPlayCalled = false
    var someError: Swift.Error?
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
