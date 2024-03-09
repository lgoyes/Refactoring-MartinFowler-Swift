//
//  ChargeCalculator.swift
//  RefactoringMartinFowler
//
//  Created by Luis David Goyes Garces on 27/1/24.
//

import Foundation

class ChargeCalculator {
    enum Error: Swift.Error {
        case unexpectedPlayType
    }
    
    #warning("TODO: Reemplazar play resolver por play directamente")
    let playResolver: PlayResolver
    let performance: Performance
    init(playResolver: PlayResolver, performance: Performance) {
        self.playResolver = playResolver
        self.performance = performance
    }
    
    func calculate() throws -> Int {
        let play = try PlayExtractor(playResolver: playResolver, playId: performance.playId).getPlay()
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
}
