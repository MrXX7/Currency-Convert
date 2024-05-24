//
//  AutomaticExchangeRatesGenerator.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import Foundation

class AutomaticExchangeRatesGenerator {
    static func generateRates(currencies: [String], exchangeRates: [String: Double], flags: [String: String], baseCurrency: String) -> [String] {
        var rates = [String]()
        
        for currency in currencies {
            if currency != baseCurrency, let rate = exchangeRates[currency] {
                let flag = flags[currency] ?? ""
                let formattedRate = String(format: "%.4f", rate)
                rates.append("\(flag) = \(formattedRate) \(currency)")
            }
        }
        
        return rates
    }
}



