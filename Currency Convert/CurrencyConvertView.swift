//
//  ContentView.swift
//  Currency Convert
//
//  Created by Oncu Can on 29.11.2023.
//

import SwiftUI
import Combine

final class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
            .compactMap { notification -> CGFloat? in
                if notification.name == UIResponder.keyboardWillShowNotification {
                    return (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height
                } else {
                    return 0
                }
            }
            .assign(to: \.currentHeight, on: self)
            .store(in: &cancellableSet)
    }
}

struct CurrencyConvertView: View {
    @State private var euroAmount = ""
    @State private var selectedCurrencyIndex = 0
    @State private var customExchangeRate = ""
    @Binding var isDarkMode: Bool
    @State private var exchangeRates: [String: Double] = [:]
    @State private var selectedRateCurrencyIndex = 0
    @StateObject private var keyboard = KeyboardResponder()
    
    @State private var showAllConversions = false

    let currencies = ["EUR", "USD", "GBP", "TRY", "CAD", "CHF", "SAR", "AUD", "CNY"]
    let flags: [String: String] = ["EUR": "🇪🇺", "USD": "🇺🇸", "GBP": "🇬🇧", "TRY": "🇹🇷", "CAD": "🇨🇦", "CHF": "🇨🇭", "SAR": "🇸🇦", "AUD": "🇦🇺", "CNY": "🇨🇳"]
    
    let quickAmounts: [String] = ["5", "10", "25", "50", "100", "200", "500", "1000"]
    
    
    private func formatAmount(_ amount: String) -> String {
        if let doubleValue = Double(amount), doubleValue.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f EUR", doubleValue)
        } else {
            return "\(amount) EUR"
        }
    }

    var body: some View {
        let convertedAmount = AmountConverter.convertAmount(euroAmount: euroAmount, customExchangeRate: customExchangeRate, selectedCurrencyIndex: selectedCurrencyIndex, exchangeRates: exchangeRates, currencies: currencies)
        
        let automaticExchangeRates = AutomaticExchangeRatesGenerator.generateRates(currencies: currencies, exchangeRates: exchangeRates, flags: flags, baseCurrency: currencies[selectedRateCurrencyIndex])
        
        let allCurrencyConversions = convertAmountForAllCurrencies(baseAmount: euroAmount, baseCurrency: currencies[selectedCurrencyIndex])

        return GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 10) { // Adjusted spacing to 10
                    HStack {
                        Spacer()
                        DarkModeToggleButton(isDarkMode: $isDarkMode)
                    }
                    .preferredColorScheme(isDarkMode ? .dark : .light)
                    
                    Text("Choose Your Currency") // Kullanıcıya açıklama ekliyoruz
                                .font(.headline)
                                .foregroundColor(.gray)
                    ExchangeRatePickerView(currencies: currencies, selectedRateCurrencyIndex: $selectedRateCurrencyIndex)
                    QuickAmountPickerView(quickAmounts: quickAmounts, euroAmount: $euroAmount)
                    AmountInputView(euroAmount: $euroAmount)
                    
                    HStack {
                        Text("Choose Currency to Convert To") // İkinci picker için açıklama
                            .font(.headline)
                            .foregroundColor(.gray)
                        Button(action: {
                            showAllConversions.toggle()
                        }) {
                            HStack {
                                    Image(systemName: "arrow.2.circlepath") // Ya da seçtiğin başka bir ikon
                                    Text("Convert All")
//                                        .font(.headline)
                                }
                        }
                    }
                    CurrencyPickerView(currencies: currencies, selectedCurrencyIndex: $selectedCurrencyIndex)
                    ExchangeRateInputView(customExchangeRate: $customExchangeRate)
                    
                    Divider() // Add divider here
                    
                    HStack {
                        TotalAmountView(convertedAmount: convertedAmount, selectedCurrency: currencies[selectedCurrencyIndex])
                        ResetButton(euroAmount: $euroAmount, customExchangeRate: $customExchangeRate, selectedCurrencyIndex: $selectedCurrencyIndex, selectedRateCurrencyIndex: $selectedRateCurrencyIndex)
                    }

//                    if showAllConversions {
//                        VStack(alignment: .leading, spacing: 1) {
//                            ForEach(allCurrencyConversions, id: \.self) { result in
//                                Text(result)
////                                    .padding(.vertical, 5)
//                            }
//                        }
//                        .padding(.leading)
//                    }
//                    
//                    
//                    AutomaticExchangeRatesView(automaticExchangeRates: automaticExchangeRates, selectedCurrency: currencies[selectedRateCurrencyIndex])
                    if showAllConversions {
                        VStack(alignment: .leading, spacing: 1) {
                            ForEach(allCurrencyConversions, id: \.self) { result in
                                Text(result)
                            }
                        }
                        .padding(.leading)
                    } else {
                        AutomaticExchangeRatesView(automaticExchangeRates: automaticExchangeRates, selectedCurrency: currencies[selectedRateCurrencyIndex])
                    }

                    
                    Text("© 2023 Öncü Can. All rights reserved.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(minWidth: geometry.size.width * 0.9) // Adjust this value to balance left and right padding
                .frame(minHeight: geometry.size.height)
                .padding(.bottom, keyboard.currentHeight) // Add bottom padding based on keyboard height
                .animation(.easeOut(duration: 0.16)) // Add animation for smooth transition
            }
        }
        .onAppear {
            fetchExchangeRates()
        }
        .onChange(of: selectedRateCurrencyIndex) { _ in
            fetchExchangeRates()
        }
    }

    private func fetchExchangeRates() {
        ExchangeRateFetcher.fetchRates(apiKey: "bdb3c5b7f1a64792427d2f13", selectedCurrencyIndex: selectedRateCurrencyIndex, currencies: currencies) { rates in
            self.exchangeRates = rates
        }
    }
    
    private func convertAmountForAllCurrencies(baseAmount: String, baseCurrency: String) -> [String] {
        guard let amount = Double(baseAmount) else { return [] }
        
        var results: [String] = []
        for currency in currencies {
            if currency != baseCurrency, let rate = exchangeRates[currency] {
                let convertedValue = amount * rate
                let formattedResult = String(format: "%.2f \(currency)", convertedValue)
                results.append("\(flags[currency] ?? "") \(formattedResult)")
            }
        }
        return results
    }

}









