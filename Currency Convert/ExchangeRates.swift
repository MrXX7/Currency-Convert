//
//  ExchangeRates.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import Foundation

struct ExchangeRatesResponse: Codable {
    let rates: [String: Double]
}
