//
//  BillPrinter.swift
//  RefactoringMartinFowler
//
//  Created by Luis David Goyes Garces on 16/12/23.
//

import Foundation

struct Play {
    let name: String
    let type: String
}

class Performance {
    let playId: String
    let audience: Int
    init(playId: String, audience: Int) {
        self.playId = playId
        self.audience = audience
    }
}

struct Invoice {
    let customer: String
    let performances: [Performance]
}

struct RenderModel {
    let customer: String
    let performances: [EnrichedPerformance]
}

class EnrichedPerformance: Performance {
    let playName: String
    let amount: Int
    let credits: Int
    
    init(performance: Performance, play: Play, amount: Int, credits: Int) {
        self.playName = play.name
        self.amount = amount
        self.credits = credits
        super.init(playId: performance.playId, audience: performance.audience)
    }
}

protocol PlayRepository {
    func getPlayFor(performance: Performance) throws -> Play
}

class DefaultPlayRepository: PlayRepository {
    enum Error: Swift.Error {
        case playNotFound
    }
    
    let plays: [String: Play]
    init(plays: [String : Play]) {
        self.plays = plays
    }
    func getPlayFor(performance: Performance) throws -> Play {
        guard let play = plays[performance.playId] else {
            throw Error.playNotFound
        }
        return play
    }
}

class BillPrinter {
    enum Error: Swift.Error {
        case unknownType(String)
        case possibleNumberOutOfRange
    }
    
    let invoice: Invoice
    let playRepository: PlayRepository
    let usdFormatter: USDFormattable
    
    init(invoice: Invoice, playRepository: PlayRepository, usdFormatter: USDFormattable = USDFormatter()) {
        self.invoice = invoice
        self.playRepository = playRepository
        self.usdFormatter = usdFormatter
    }
    
    func statement() throws -> String {
        let invoice = RenderModel(
            customer: invoice.customer,
            performances: try invoice.performances.map({ EnrichedPerformance(performance: $0, play: try playRepository.getPlayFor(performance: $0), amount: try PerformanceAmountCalculator(performance: $0, playRepository: playRepository).compute(), credits: try VolumeCreditsCalculator(performance: $0, playRepository: playRepository).calculate() ) })
        )
        return try renderPlainText(invoice)
    }
    
    func renderPlainText(_ invoice: RenderModel) throws -> String {
        var result = "Statement for \(invoice.customer)\n"
        for perf in invoice.performances {
            result += "   \(perf.playName): \(try usdFormatter.format(amountInCents: perf.amount)) (\(perf.audience)) seats\n"
        }
        
        let totalAmount = try computeTotalAmount(amounts: invoice.performances.map({ $0.amount }))
        result += "Amount owed is \(try usdFormatter.format(amountInCents: totalAmount))\n"
        result += "You earned \(try computeTotalVolumeCredits(credits: invoice.performances.map({ $0.credits }))) credits"
        
        return result
    }
    
    func statementHTML() throws -> String {
        let invoice = RenderModel(
            customer: invoice.customer,
            performances: try invoice.performances.map({ EnrichedPerformance(performance: $0, play: try playRepository.getPlayFor(performance: $0), amount: try PerformanceAmountCalculator(performance: $0, playRepository: playRepository).compute(), credits: try VolumeCreditsCalculator(performance: $0, playRepository: playRepository).calculate() ) })
        )
        return try renderHTML(invoice)
    }
    
    func renderHTML(_ invoice: RenderModel) throws -> String {
        var result = "<h1>Statement for \(invoice.customer)</h1>\n"
        result += "<table>\n"
        result += "<tr><th>Play</th><th>Seats</th><th>Cost</th></tr>\n"
        for perf in invoice.performances {
            let play = try playRepository.getPlayFor(performance: perf)
            result += "   <tr>"
            result += "<td>\(play.name)</td>"
            result += "<td>\(perf.audience)</td>"
            result += "<td>\(try usdFormatter.format(amountInCents: perf.amount))</td>"
            result += "</tr>\n"
        }
        result += "</table>\n"
        let totalAmount = try computeTotalAmount(amounts: invoice.performances.map({ $0.amount }))
        result += "<p>Amount owed is <em>\(try usdFormatter.format(amountInCents: totalAmount))</em></p>\n"
        result += "<p>You earned <em>\(try computeTotalVolumeCredits(credits: invoice.performances.map({ $0.credits })))</em> credits</p>"
        
        return result
    }
    
    func computeTotalAmount(amounts: [Int]) throws -> Int {
        let initialTotalAmount = 0
        return amounts.reduce(initialTotalAmount) { partialResult, thisAmount in
            return partialResult + thisAmount
        }
    }
    
    func computeTotalVolumeCredits(credits: [Int]) throws -> Int {
        let volumeCredits = 0
        return credits.reduce(volumeCredits) { partialResult, credit in
            return partialResult + credit
        }
    }
}
