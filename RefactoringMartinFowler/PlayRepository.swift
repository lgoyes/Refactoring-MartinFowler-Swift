//
//  PlayRepository.swift
//  RefactoringMartinFowler
//
//  Created by Luis David Goyes Garces on 20/1/24.
//

import Foundation

protocol PlayResolver {
    func getPlay(for performance: Performance) throws -> Play
}

class PlayRepository {
    enum Error: Swift.Error {
        case playNotFound
    }
    
    let plays: [String: Play]
    init(plays: [String : Play]) {
        self.plays = plays
    }
}

extension PlayRepository: PlayResolver {
    func getPlay(for performance: Performance) throws -> Play {
        guard let play = plays[performance.playId] else {
            throw Error.playNotFound
        }
        return play
    }
}