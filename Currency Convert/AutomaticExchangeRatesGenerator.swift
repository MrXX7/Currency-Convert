//
//  AutomaticExchangeRatesGenerator.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import Foundation

enum AutomaticExchangeRatesGenerator {
    static func generateRates(baseCurrencyCode: String, exchangeRates: [String: Double]) -> [CurrencyRate] {
        CurrencyCatalog.supported
            .filter { $0.code != baseCurrencyCode }
            .compactMap { currency in
                guard let rate = exchangeRates[currency.code] else {
                    return nil
                }

                return CurrencyRate(currency: currency, rate: rate)
            }
            .sorted { $0.currency.code < $1.currency.code }
    }
}

