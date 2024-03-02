//
//  ChargeCalculator.swift
//  RefactoringMartinFowler
//
//  Created by Luis David Goyes Garces on 27/1/24.
//

import Foundation

class ChargeCalculator {
    enum Error: Swift.Error {
        case invalidPlayIdForPerformance
        case unexpectedPlayType
    }
    
    let playResolver: PlayResolver
    let performance: Performance
    init(playResolver: PlayResolver, performance: Performance) {
        self.playResolver = playResolver
        self.performance = performance
    }
    
    func calculate() throws -> Int {
        let play = try getPlay()
        if (play.type == "tragedy") {
            var charge = 40_000
            if performance.audience > 30 {
                charge += 1_000 * (performance.audience - 30)
            }
            return charge
        } else if (play.type == "comedy") {
            var charge = 30_000
            if performance.audience > 20 {
                charge += 10_000 + 500 * (performance.audience - 20)
            }
            charge += 300 * performance.audience
            return charge
        } else {
            throw Error.unexpectedPlayType
        }
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
