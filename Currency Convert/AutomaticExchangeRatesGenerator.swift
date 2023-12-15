//
//  AutomaticExchangeRatesGenerator.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import Foundation

class AutomaticExchangeRatesGenerator {
    static func generateRates(currencies: [String], exchangeRates: [String: Double], flags: [String: String]) -> [String] {
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
                return "1 \(flags[currency] ?? "") = \(rate) \(currency)"
            }
            return "\(flags[currency] ?? "") \(currency) = \(formattedRate)"

        }

        return automaticExchangeRates
    }
}

// Kullanım örneği:
let currencies = ["USD", "GBP", "JPY"]
let exchangeRates: [String: Double] = ["USD": 1.12, "GBP": 0.85, "JPY": 130.0]
let flags: [String: String] = ["USD": "🇺🇸", "GBP": "🇬🇧", "JPY": "🇯🇵", "TRY": "🇹🇷", "CAD": "🇨🇦", "CHF": "🇨🇭", "SAR": "🇸🇦", "AUD": "🇦🇺", "CNY": "🇨🇳"]

let rates = AutomaticExchangeRatesGenerator.generateRates(currencies: currencies, exchangeRates: exchangeRates, flags: flags)


