//
//  AmountConverter.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import Foundation

class AmountConverter {
    static func convertAmount(euroAmount: String, customExchangeRate: String, selectedCurrencyIndex: Int, exchangeRates: [String: Double], currencies: [String]) -> Double {
        // Convert the user-entered text to a decimal number using a NumberFormatter.
        let formatter = NumberFormatter()
        formatter.locale = Locale.current  // Use the user's locale.
        formatter.decimalSeparator = ","
        
        if let euroValue = formatter.number(from: euroAmount)?.doubleValue {
            var selectedRate = exchangeRates[currencies[selectedCurrencyIndex]] ?? 0.0
            
            // Use the custom exchange rate if provided.
            if let customRate = formatter.number(from: customExchangeRate)?.doubleValue {
                selectedRate = customRate
            }
            
            // Use the selected rate for conversion.
            let convertedAmount = euroValue * selectedRate
            return convertedAmount
        } else {
            return 0  // Return the default value if conversion fails.
        }
    }
}



