//
//  PerformanceAmountCalculator.swift
//  RefactoringMartinFowler
//
//  Created by Luis David Goyes Garces on 13/1/24.
//

import Foundation

class PerformanceAmountCalculator {
    enum Error: Swift.Error {
        case unknownType(String)
    }
    
    let performance: Performance
    let playRepository: PlayRepository
    init(performance: Performance, playRepository: PlayRepository) {
        self.performance = performance
        self.playRepository = playRepository
    }
    
    func compute() throws -> Int {
        var charge = 0
        
        let play = try playRepository.getPlayFor(performance: performance)
        switch play.type {
        case "tragedy":
            charge = 40_000
            if performance.audience > 30 {
                charge += 1_000 * (performance.audience - 30)
            }
        case "comedy":
            charge = 30_000
            if performance.audience > 20 {
                charge += 10_000 + 500 * (performance.audience - 20)
            }
            charge += 300 * performance.audience
        default:
            throw Error.unknownType(play.type)
        }
        
        return charge
    }
}
