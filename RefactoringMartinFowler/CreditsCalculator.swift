//
//  CreditsCalculator.swift
//  RefactoringMartinFowler
//
//  Created by Luis David Goyes Garces on 3/2/24.
//

import Foundation

class CreditsCalculator {
    private enum Constant {
        static let audienceThreshold = 30
        static let minimumCredits = 0
        static let audienceToCreditsConversionFactor = 1.0 / 5.0
    }
    
    enum Error: Swift.Error {
        case invalidPlayIdForPerformance
    }
    
    let playResolver: PlayResolver
    let performance: Performance
    init(playResolver: PlayResolver, performance: Performance) {
        self.playResolver = playResolver
        self.performance = performance
    }
    
    func calculate() throws -> Int {
        var credits = max(performance.audience - Constant.audienceThreshold, Constant.minimumCredits)
        let play = try getPlay()
        if (play.type == "comedy") {
            credits += Int(floor(Double(performance.audience) * Constant.audienceToCreditsConversionFactor))
        }
        return credits
    }
    
    private func getPlay() throws -> Play {
        do {
            let play = try playResolver.getPlay(for: performance.playId)
            return play
        } catch {
            throw Error.invalidPlayIdForPerformance
        }
    }
}
