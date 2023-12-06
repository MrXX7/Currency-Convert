//
//  AutomaticExchangeRatesGenerator.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import Foundation

class AutomaticExchangeRatesGenerator {
    static func generateRates(currencies: [String], exchangeRates: [String: Double]) -> [String] {
        let automaticExchangeRates: [String] = currencies.compactMap { currency in
            if currency.localizedCaseInsensitiveCompare("EUR") == .orderedSame {
                return nil
            }

            let rate = exchangeRates[currency] ?? 0.0

            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 4
            formatter.numberStyle = .decimal

            guard let formattedRate = formatter.string(from: NSNumber(value: rate)) else {
                print("Formatting Error for \(currency)")
                return "1€ = \(rate) \(currency)"
            }

            return "1€ = \(formattedRate) \(currency)"
        }

        return automaticExchangeRates
    }
}

