//
//  PlayExtractor.swift
//  RefactoringMartinFowler
//
//  Created by Luis David Goyes Garces on 9/3/24.
//

import Foundation

class PlayExtractor {
    enum Error: Swift.Error {
        case invalidPlayId
    }

    let playResolver: PlayResolver
    let playId: String
    init(playResolver: PlayResolver, playId: String) {
        self.playResolver = playResolver
        self.playId = playId
    }
    
    func getPlay() throws -> Play {
        do {
            let play = try playResolver.getPlay(for: playId)
            return play
        } catch {
            throw Error.invalidPlayId
        }
    }
}
