//
//  VolumeCreditsCalculator.swift
//  RefactoringMartinFowler
//
//  Created by Luis David Goyes Garces on 13/1/24.
//

import Foundation

class VolumeCreditsCalculator {
    let performance: Performance
    let playRepository: PlayRepository
    init(performance: Performance, playRepository: PlayRepository) {
        self.performance = performance
        self.playRepository = playRepository
    }
    
    func calculate() throws -> Int {
        var volumeCredits = max(performance.audience - 30, 0)
        let play = try playRepository.getPlayFor(performance: performance)
        if (play.type == "comedy") {
            volumeCredits += Int(floor(Double(performance.audience) / 5.0))
        }
        return volumeCredits
    }
}
