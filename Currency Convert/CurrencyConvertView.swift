//
//  ContentView.swift
//  Currency Convert
//
//  Created by Oncu Can on 29.11.2023.
//

import SwiftUI
import Alamofire

struct CurrencyConvertView: View {
    @State private var euroAmount = ""
    @State private var selectedCurrencyIndex = 0
    @State private var customExchangeRate = ""
    @State private var isDarkMode = false
    @State private var exchangeRates: [String: Double] = [:]

    let currencies = ["EUR", "USD", "GBP", "TRY", "CAD", "CHF", "SAR", "AUD"]

    // Retrieve exchange rate information using the ExchangeRate-API endpoint URL along with an API Key
    func fetchExchangeRates() {
        let apiKey = "de15ae4ba4d18dfc91aac6f9def9c932"

        let url = "https://open.er-api.com/v6/latest/\(currencies[selectedCurrencyIndex])?apikey=\(apiKey)"

        AF.request(url).responseDecodable(of: ExchangeRatesResponse.self) { response in
            guard let rates = response.value?.rates else {
                return
            }
            
            // Use the obtained exchange rate information.
            self.exchangeRates = rates
        }
    }

    var body: some View {
        let resetButton: some View = {
                    Button(action: {
                        // Reset işlemi burada gerçekleşecek.
                        euroAmount = ""
                        customExchangeRate = ""
                    }) {
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                            .foregroundColor(Color(.systemRed))
                            .padding()
                    }
                }()
        let convertedAmount: Double = {
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
        }()

        let automaticExchangeRates: [String] = currencies.map { currency in
            let rate = exchangeRates[currency] ?? 0.0

            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 4
            formatter.numberStyle = .decimal

            guard let formattedRate = formatter.string(from: NSNumber(value: rate)) else {
                return "1€ = \(rate) \(currency)"
            }

            return "1€ = \(formattedRate) \(currency)"
        }

        return VStack {
            HStack {
                Spacer()
                Button(action: {
                    // Toggle Dark Mode.
                    isDarkMode.toggle()
                    // Apply Dark Mode
                    if isDarkMode {
                        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
                    } else {
                        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
                    }
                }) {
                    Image(systemName: isDarkMode ? "moon.fill" : "moon")
                        .foregroundColor(isDarkMode ? .yellow : .blue)
                        .padding()
                }
            }
            Spacer()

            TextField("Enter Amount", text: $euroAmount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .font(.title2)
                    .onTapGesture {
                    // Resolve bug: DecimalPad now closes when tapping outside the text field.
                        UIApplication.shared.windows.first?.endEditing(true)
                    }

            Picker("", selection: $selectedCurrencyIndex) {
                ForEach(0..<currencies.count) {
                    Text(self.currencies[$0])
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            HStack {
                Text("Exchange Rate:")
                    .font(.title2)
                TextField("Enter Rate", text: $customExchangeRate) {
                    // Close Decimal
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .font(.title2)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
            }
            .padding(.vertical, 8)

            // Display the total amount with the appropriate currency.
            HStack {
                Text("Total Amount: \(convertedAmount, specifier: "%.2f") \(currencies[selectedCurrencyIndex])")
                    .padding()
                    .font(.title2)
                Spacer()
                resetButton
            }
            
            Divider()
                .padding()

            ForEach(automaticExchangeRates, id: \.self) { rate in
                Text(rate)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.bottom, 2) // A little padding between each automatic exchange rate
            }

            Spacer()
            
            // Copyright Signature
            Text("© 2023 Öncü Can. All rights reserved.")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
        
        .onAppear {
            // Fetch exchange rate information when the page appears.
            fetchExchangeRates()
        }
    }
}

struct ExchangeRatesResponse: Decodable {
    let rates: [String: Double]
}

struct CurrencyConvertView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyConvertView()
    }
}




