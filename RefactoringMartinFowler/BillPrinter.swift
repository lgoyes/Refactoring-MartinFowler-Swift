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
    
    init(performance: Performance, play: Play) {
        self.playName = play.name
        super.init(playId: performance.playId, audience: performance.audience)
    }
}

class BillPrinter {
    enum Error: Swift.Error {
        case unknownType(String)
        case possibleNumberOutOfRange
    }
    
    let invoice: Invoice
    let plays: [String: Play]
    let usdFormatter: USDFormattable
    
    init(invoice: Invoice, plays: [String : Play], usdFormatter: USDFormattable = USDFormatter()) {
        self.invoice = invoice
        self.plays = plays
        self.usdFormatter = usdFormatter
    }
    
    func statement() throws -> String {
        let invoice = RenderModel(
            customer: invoice.customer,
            performances: invoice.performances.map({ EnrichedPerformance(performance: $0, play: getPlayFor(performance: $0)) })
        )
        return try renderPlainText(invoice)
    }
    
    func renderPlainText(_ invoice: RenderModel) throws -> String {
        var result = "Statement for \(invoice.customer)\n"
        for perf in invoice.performances {
            let thisAmount = try computeAmountFor(performance: perf)
            result += "   \(perf.playName): \(try usdFormatter.format(amountInCents: thisAmount)) (\(perf.audience)) seats\n"
        }
        
        let totalAmount = try computeTotalAmount()
        result += "Amount owed is \(try usdFormatter.format(amountInCents: totalAmount))\n"
        result += "You earned \(computeTotalVolumeCredits()) credits"
        
        return result
    }
    
    func statementHTML() throws -> String {
        let invoice = RenderModel(
            customer: invoice.customer,
            performances: invoice.performances.map({ EnrichedPerformance(performance: $0, play: getPlayFor(performance: $0)) })
        )
        return try renderHTML(invoice)
    }
    
    func renderHTML(_ invoice: RenderModel) throws -> String {
        var result = "<h1>Statement for \(invoice.customer)</h1>\n"
        result += "<table>\n"
        result += "<tr><th>Play</th><th>Seats</th><th>Cost</th></tr>\n"
        for perf in invoice.performances {
            let play = getPlayFor(performance: perf)
            let thisAmount = try computeAmountFor(performance: perf)
            result += "   <tr>"
            result += "<td>\(play.name)</td>"
            result += "<td>\(perf.audience)</td>"
            result += "<td>\(try usdFormatter.format(amountInCents: thisAmount))</td>"
            result += "</tr>\n"
        }
        result += "</table>\n"
        let totalAmount = try computeTotalAmount()
        result += "<p>Amount owed is <em>\(try usdFormatter.format(amountInCents: totalAmount))</em></p>\n"
        result += "<p>You earned <em>\(computeTotalVolumeCredits())</em> credits</p>"
        
        return result
    }
    
    func computeTotalAmount() throws -> Int {
        let initialTotalAmount = 0
        return try invoice.performances.reduce(initialTotalAmount) { partialResult, performance in
            let thisAmount = try computeAmountFor(performance: performance)
            return partialResult + thisAmount
        }
    }
    
    func computeTotalVolumeCredits() -> Int {
        var volumeCredits = 0
        for perf in invoice.performances {
            volumeCredits += getVolumeCreditsFor(performance: perf)
        }
        return volumeCredits
    }
    
    func getVolumeCreditsFor(performance: Performance) -> Int {
        var volumeCredits = max(performance.audience - 30, 0)
        let play = getPlayFor(performance: performance)
        if (play.type == "comedy") {
            volumeCredits += Int(floor(Double(performance.audience) / 5.0))
        }
        return volumeCredits
    }
    
    func getPlayFor(performance: Performance) -> Play {
        plays[performance.playId]!
    }
    
    func computeAmountFor(performance: Performance) throws -> Int {
        var charge = 0
        
        switch getPlayFor(performance: performance).type {
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
            throw Error.unknownType(getPlayFor(performance: performance).type)
        }
        
        return charge
    }
}
