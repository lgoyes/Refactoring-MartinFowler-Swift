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
    
    func getPlay() throws -> Play {
        do {
            let play = try playResolver.getPlay(for: performance)
            return play
        } catch {
            throw Error.invalidPlayIdForPerformance
        }
    }
    
//    func computeAmountFor(performance: Performance) throws -> Int {
//        var charge = 0
//        
//        switch try playResolver.getPlay(for: performance).type {
//        case "tragedy":
//            charge = 40_000
//            if performance.audience > 30 {
//                charge += 1_000 * (performance.audience - 30)
//            }
//        case "comedy":
//            charge = 30_000
//            if performance.audience > 20 {
//                charge += 10_000 + 500 * (performance.audience - 20)
//            }
//            charge += 300 * performance.audience
//        default:
//            throw Error.unknownType(try playResolver.getPlay(for: performance).type)
//        }
//        
//        return charge
//    }
}
