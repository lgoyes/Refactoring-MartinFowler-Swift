//
//  BillLineItemFactory.swift
//  RefactoringMartinFowler
//
//  Created by Luis David Goyes Garces on 9/3/24.
//

import Foundation

class BillLineItemFactory {
    let performance: Performance
    let playResolver: PlayResolver
    init(performance: Performance, playResolver: PlayResolver) {
        self.performance = performance
        self.playResolver = playResolver
    }
    func create() throws -> BillLineItem {
        let play = try PlayExtractor(playResolver: playResolver, playId: performance.playId).getPlay()
        let performanceAmount = try ChargeCalculator(playResolver: playResolver, performance: performance).calculate()
        return BillLineItem(playName: play.name, amountInCents: performanceAmount, audience: performance.audience)
    }
}
