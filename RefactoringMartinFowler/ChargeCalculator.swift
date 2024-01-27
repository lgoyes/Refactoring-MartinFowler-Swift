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
    }
    
    let playResolver: PlayResolver
    let performance: Performance
    init(playResolver: PlayResolver, performance: Performance) {
        self.playResolver = playResolver
        self.performance = performance
    }
    
    func calculate() throws -> Int {
        do {
            let play = try playResolver.getPlay(for: performance)
            if (play.type == "tragedy") {
                return 650
            } else if (play.type == "comedy") {
                return 580
            }
            return 0
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
