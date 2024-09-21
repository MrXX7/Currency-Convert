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
                VStack(spacing: 5) {
                    HStack {
                        Spacer()
                        DarkModeToggleButton(isDarkMode: $isDarkMode)
                    }
                    
                    .preferredColorScheme(isDarkMode ? .dark : .light)
                    .padding(.horizontal, 10)
                    
                    Text("Choose Your Currency")
                        .font(.system(size: geometry.size.width > 320 ? 16 : 14)) // iPhone SE için daha küçük font

                                .foregroundColor(.gray)
                    ExchangeRatePickerView(currencies: currencies, selectedRateCurrencyIndex: $selectedRateCurrencyIndex)
                        .frame(maxWidth: .infinity)
                    QuickAmountPickerView(quickAmounts: quickAmounts, euroAmount: $euroAmount)
                        .frame(maxWidth: .infinity)
                    AmountInputView(euroAmount: $euroAmount)
                        .frame(maxWidth: .infinity)
                    
                    Text("Choose Currency to Convert To")
                        .font(.system(size: geometry.size.width > 320 ? 16 : 14))
                        .foregroundColor(.gray)
                        .font(.system(size: 14, weight: .medium, design: .default))
                        
                    CurrencyPickerView(currencies: currencies, selectedCurrencyIndex: $selectedCurrencyIndex)
                        .frame(maxWidth: .infinity)
                    Button(action: {
                        showAllConversions.toggle()
                    }) {
                        HStack {
                                Image(systemName: "arrow.2.circlepath")
                                Text("Convert All")
                                .font(.footnote)
                            }
                        
                    }.frame(maxWidth: .infinity)
                    ExchangeRateInputView(customExchangeRate: $customExchangeRate)
                    
                    Divider() // Add divider here
                    
                    HStack {
                        TotalAmountView(convertedAmount: convertedAmount, selectedCurrency: currencies[selectedCurrencyIndex])
                        Spacer() // Çok büyük boşluk bırakmaması için ekran boyutuna göre ayarlanabilir
                        ResetButton(euroAmount: $euroAmount, customExchangeRate: $customExchangeRate, selectedCurrencyIndex: $selectedCurrencyIndex, selectedRateCurrencyIndex: $selectedRateCurrencyIndex)
                    }
                    .frame(maxWidth: .infinity) // Ekrana göre genişliği ayarla

                    if showAllConversions {
                        VStack(alignment: .leading, spacing: 2) {
                            ForEach(allCurrencyConversions, id: \.self) { result in
                                Text(result)
                                    .font(.subheadline)
                                    .padding(.leading, -70)
                            }
                        }
                        .padding(.leading, -90)
                        .transition(.slide)
                        .animation(.easeInOut(duration: 0.8))
                    } else {
                        AutomaticExchangeRatesView(automaticExchangeRates: automaticExchangeRates, selectedCurrency: currencies[selectedRateCurrencyIndex])
                            .transition(.slide)
                            .animation(.easeInOut)
                    }

                    Text("© 2023 Öncü Can. All rights reserved.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity)
                    .frame(minHeight: geometry.size.height)
                    .padding(.bottom, keyboard.currentHeight)
                    .animation(.easeOut(duration: 0.6))
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









