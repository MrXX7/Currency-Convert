//
//  AmountConverter.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import Foundation

enum AmountConverter {
    private static let parseFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .current
        formatter.generatesDecimalNumbers = true
        return formatter
    }()

    private static let outputFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .current
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    static func sanitize(_ value: String) -> String {
        let decimalSeparator = Locale.current.decimalSeparator ?? ","
        let alternativeSeparator = decimalSeparator == "," ? "." : ","

        var sanitized = value
            .replacingOccurrences(of: alternativeSeparator, with: decimalSeparator)
            .filter { $0.isWholeNumber || String($0) == decimalSeparator }

        let components = sanitized.components(separatedBy: decimalSeparator)
        if components.count > 2 {
            sanitized = components.prefix(2).joined(separator: decimalSeparator)
        }

        return sanitized
    }

    static func decimalValue(from input: String) -> Double? {
        let sanitized = sanitize(input)
        return parseFormatter.number(from: sanitized)?.doubleValue
    }

    static func convertedAmount(
        amountInput: String,
        customRateInput: String,
        targetCurrencyCode: String,
        rates: [String: Double]
    ) -> Double {
        guard let amount = decimalValue(from: amountInput) else {
            return 0
        }

        let selectedRate = decimalValue(from: customRateInput) ?? rates[targetCurrencyCode] ?? 0
        return amount * selectedRate
    }

    static func formattedAmount(_ value: Double, currencyCode: String) -> String {
        let amountText = outputFormatter.string(from: NSNumber(value: value)) ?? String(format: "%.2f", value)
        return "\(amountText) \(currencyCode)"
    }
}

