//
//  ExchangeRateFetcher.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import Foundation

struct ExchangeRateSnapshot {
    let baseCurrencyCode: String
    let rates: [String: Double]
    let updateTimestamp: Date?
}

enum ExchangeRateError: LocalizedError {
    case invalidResponse
    case missingRates

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Could not load exchange rates right now."
        case .missingRates:
            return "The rates feed returned incomplete data."
        }
    }
}

enum ExchangeRateFetcher {
    static func fetchRates(baseCurrencyCode: String) async throws -> ExchangeRateSnapshot {
        let url = URL(string: "https://open.er-api.com/v6/latest/\(baseCurrencyCode)")!
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw ExchangeRateError.invalidResponse
        }

        let decoded = try JSONDecoder().decode(ExchangeRatesResponse.self, from: data)
        guard !decoded.rates.isEmpty else {
            throw ExchangeRateError.missingRates
        }

        return ExchangeRateSnapshot(
            baseCurrencyCode: decoded.baseCode ?? baseCurrencyCode,
            rates: decoded.rates,
            updateTimestamp: parsedDate(from: decoded.updateTimeUTC)
        )
    }

    private static func parsedDate(from value: String?) -> Date? {
        guard let value else {
            return nil
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        return formatter.date(from: value)
    }
}

