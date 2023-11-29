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

    let currencies = ["USD", "EUR", "GBP", "JPY", "TRY"]

    var exchangeRates: [Double] {
        var rates = [1.108, 1.0, 0.85, 135, 31.81]  //
        
        if let customRate = Double(customExchangeRate) {
            rates[selectedCurrencyIndex] = customRate
        }

        return rates
    }

    var convertedAmount: Double {
        let euroValue = Double(euroAmount) ?? 0
        let selectedRate = exchangeRates[selectedCurrencyIndex]
        return euroValue * selectedRate
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
