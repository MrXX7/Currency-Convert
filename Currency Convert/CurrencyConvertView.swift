//
//  ContentView.swift
//  Currency Convert
//
//  Created by Oncu Can on 29.11.2023.
//

import SwiftUI

struct CurrencyConvertView: View {
    @State private var euroAmount = ""
    @State private var selectedCurrencyIndex = 0
    @State private var customExchangeRate = ""

    let currencies = ["USD", "EUR", "GBP", "JPY", "TRY", "CAD", "CHF", "SAR"]

    var exchangeRates: [Double] {
        var rates = [1.108, 1.0, 0.85, 135, 31.81, 1.28, 1.09, 4.18]  // Realistic exchange rates.
        
        // Manually entered exchange rate by the user.
        if let customRate = Double(customExchangeRate.replacingOccurrences(of: ",", with: ".")) {
            rates[selectedCurrencyIndex] = customRate
        }

        return rates
    }

    var convertedAmount: Double {
        // Convert the user-entered text to a decimal number using a NumberFormatter.
        let formatter = NumberFormatter()
        formatter.locale = Locale.current  // Use the user's locale.
        formatter.decimalSeparator = ","

        if let euroValue = formatter.number(from: euroAmount)?.doubleValue {
            let selectedRate = exchangeRates[selectedCurrencyIndex]
            return euroValue * selectedRate
        } else {
            return 0  // Return the default value if conversion fails.
        }
    }

    var body: some View {
        VStack {
            TextField("Enter Euro Amount", text: $euroAmount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)

            Picker("Currency", selection: $selectedCurrencyIndex) {
                ForEach(0..<currencies.count) {
                    Text(self.currencies[$0])
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            HStack {
                Text("Exchange Rate:")
                TextField("Enter Custom Rate", text: $customExchangeRate)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
            }
            .padding(.vertical, 8)

            // Display the total amount with the appropriate currency.
            Text("Total Amount: \(convertedAmount, specifier: "%.2f") \(currencies[selectedCurrencyIndex])")
                .padding()
        }
        .padding()
    }
}

struct CurrencyConvertView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyConvertView()
    }
}




