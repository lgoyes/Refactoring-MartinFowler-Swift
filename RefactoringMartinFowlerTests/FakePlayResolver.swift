//
//  FakePlayResolver.swift
//  RefactoringMartinFowlerTests
//
//  Created by Luis David Goyes Garces on 3/2/24.
//

import Foundation
@testable import RefactoringMartinFowler

class FakePlayResolver: PlayResolver {
    var receivedPlayId: String!
    var getPlayCalled = false
    var someError: Swift.Error?
    var somePlay: Play!
    
    func getPlay(for playId: String) throws -> Play {
        getPlayCalled = true
        receivedPlayId = playId
        if let someError {
            throw someError
        }
        return somePlay
    }
}
