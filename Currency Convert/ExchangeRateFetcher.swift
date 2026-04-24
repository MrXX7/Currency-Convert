//
//  ExchangeRateFetcher.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import Foundation

enum ExchangeRateSource: String, Codable {
    case live
    case cache
}

struct ExchangeRateSnapshot {
    let baseCurrencyCode: String
    let rates: [String: Double]
    let updateTimestamp: Date?
    let source: ExchangeRateSource
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
        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                throw ExchangeRateError.invalidResponse
            }

            let decoded = try JSONDecoder().decode(ExchangeRatesResponse.self, from: data)
            guard !decoded.rates.isEmpty else {
                throw ExchangeRateError.missingRates
            }

            let snapshot = ExchangeRateSnapshot(
                baseCurrencyCode: decoded.baseCode ?? baseCurrencyCode,
                rates: decoded.rates,
                updateTimestamp: parsedDate(from: decoded.updateTimeUTC),
                source: .live
            )

            store(snapshot: snapshot, for: baseCurrencyCode)
            return snapshot
        } catch {
            if let cachedSnapshot = cachedSnapshot(for: baseCurrencyCode) {
                return cachedSnapshot
            }

            throw error
        }
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

    private static func store(snapshot: ExchangeRateSnapshot, for baseCurrencyCode: String) {
        let cached = CachedExchangeRateSnapshot(
            baseCurrencyCode: snapshot.baseCurrencyCode,
            rates: snapshot.rates,
            updateTimestamp: snapshot.updateTimestamp
        )

        guard let data = try? JSONEncoder().encode(cached) else {
            return
        }

        UserDefaults.standard.set(data, forKey: cacheKey(for: baseCurrencyCode))
    }

    private static func cachedSnapshot(for baseCurrencyCode: String) -> ExchangeRateSnapshot? {
        guard
            let data = UserDefaults.standard.data(forKey: cacheKey(for: baseCurrencyCode)),
            let cached = try? JSONDecoder().decode(CachedExchangeRateSnapshot.self, from: data)
        else {
            return nil
        }

        return ExchangeRateSnapshot(
            baseCurrencyCode: cached.baseCurrencyCode,
            rates: cached.rates,
            updateTimestamp: cached.updateTimestamp,
            source: .cache
        )
    }

    private static func cacheKey(for baseCurrencyCode: String) -> String {
        "cachedExchangeRates_\(baseCurrencyCode)"
    }
}

private struct CachedExchangeRateSnapshot: Codable {
    let baseCurrencyCode: String
    let rates: [String: Double]
    let updateTimestamp: Date?
}
