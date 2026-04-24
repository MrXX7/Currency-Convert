//
//  ExchangeRates.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import Foundation

struct CurrencyDefinition: Identifiable, Hashable {
    let code: String
    let name: String
    let symbol: String
    let flag: String
    let region: String
    let description: String

    var id: String { code }
}

enum CurrencyCatalog {
    static let supported: [CurrencyDefinition] = [
        CurrencyDefinition(code: "EUR", name: "Euro", symbol: "€", flag: "🇪🇺", region: "European Union", description: "A major reserve currency used across much of Europe."),
        CurrencyDefinition(code: "USD", name: "US Dollar", symbol: "$", flag: "🇺🇸", region: "United States", description: "The dominant global reserve currency and benchmark for world trade."),
        CurrencyDefinition(code: "GBP", name: "Pound Sterling", symbol: "£", flag: "🇬🇧", region: "United Kingdom", description: "A mature, liquid currency with long-standing global significance."),
        CurrencyDefinition(code: "TRY", name: "Turkish Lira", symbol: "₺", flag: "🇹🇷", region: "Turkey", description: "Turkey's local currency, often monitored for volatility and inflation impact."),
        CurrencyDefinition(code: "CAD", name: "Canadian Dollar", symbol: "C$", flag: "🇨🇦", region: "Canada", description: "A commodity-linked currency with strong ties to energy markets."),
        CurrencyDefinition(code: "CHF", name: "Swiss Franc", symbol: "CHF", flag: "🇨🇭", region: "Switzerland", description: "Widely viewed as a safe-haven currency in risk-off environments."),
        CurrencyDefinition(code: "SAR", name: "Saudi Riyal", symbol: "SAR", flag: "🇸🇦", region: "Saudi Arabia", description: "A Gulf-region currency closely connected to energy exports."),
        CurrencyDefinition(code: "AUD", name: "Australian Dollar", symbol: "A$", flag: "🇦🇺", region: "Australia", description: "A trade-sensitive currency often linked to commodities and China demand."),
        CurrencyDefinition(code: "CNY", name: "Chinese Yuan", symbol: "¥", flag: "🇨🇳", region: "China", description: "One of the most watched currencies due to China's role in global trade.")
    ]

    static func currency(code: String) -> CurrencyDefinition {
        supported.first(where: { $0.code == code }) ?? supported[0]
    }
}

struct CurrencyRate: Identifiable, Hashable {
    let currency: CurrencyDefinition
    let rate: Double

    var id: String { currency.code }
}

struct ConversionResult: Identifiable, Hashable {
    let currency: CurrencyDefinition
    let amount: Double

    var id: String { currency.code }
}

struct ExchangeRatesResponse: Decodable {
    let result: String?
    let baseCode: String?
    let updateTimeUTC: String?
    let rates: [String: Double]

    enum CodingKeys: String, CodingKey {
        case result
        case rates
        case baseCode = "base_code"
        case updateTimeUTC = "time_last_update_utc"
    }
}

