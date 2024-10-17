//
//  ContentView.swift
//  Currency Convert
//
//  Created by Oncu Can on 29.11.2023.
//

import SwiftUI
import Combine

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

    var body: some View {
        let convertedAmount = AmountConverter.convertAmount(euroAmount: euroAmount, customExchangeRate: customExchangeRate, selectedCurrencyIndex: selectedCurrencyIndex, exchangeRates: exchangeRates, currencies: currencies)
        
        let automaticExchangeRates = AutomaticExchangeRatesGenerator.generateRates(currencies: currencies, exchangeRates: exchangeRates, flags: flags, baseCurrency: currencies[selectedRateCurrencyIndex])
        
        let allCurrencyConversions = convertAmountForAllCurrencies(baseAmount: euroAmount, baseCurrency: currencies[selectedCurrencyIndex])

        return GeometryReader { geometry in
            ScrollView {
                VStack {
                    VStack(spacing: 5) {
                        // Dark Mode Toggle
                        HStack {
                            Spacer()
                            DarkModeToggleButton(isDarkMode: $isDarkMode)
                        }
                        .padding(.horizontal, 10)
                        .preferredColorScheme(isDarkMode ? .dark : .light)
                        
                        // Currency Selection Header
                        Text("Choose Your Currency")
                            .font(.system(size: geometry.size.width > 320 ? 16 : 14)) // Adjust font for small devices
                            .foregroundColor(.gray)
                        
                        // Currency Picker
                        ExchangeRatePickerView(currencies: currencies, selectedRateCurrencyIndex: $selectedRateCurrencyIndex)
                            .frame(maxWidth: .infinity)
                        
                        // Quick Amount Picker
                        QuickAmountPickerView(quickAmounts: quickAmounts, euroAmount: $euroAmount)
                            .frame(maxWidth: .infinity)
                        
                        // Amount Input Field
                        AmountInputView(euroAmount: $euroAmount)
                            .frame(maxWidth: .infinity)
                        
                        // Conversion Header
                        Text("Choose Currency to Convert To")
                            .font(.system(size: geometry.size.width > 320 ? 16 : 14))
                            .foregroundColor(.gray)
                        
                        // Currency Picker for Conversion
                        CurrencyPickerView(currencies: currencies, selectedCurrencyIndex: $selectedCurrencyIndex)

                        AllConversionsButtonView(showAllConversions: $showAllConversions, euroAmount: $euroAmount)
                        
                        ExchangeRateInputView(customExchangeRate: $customExchangeRate)
                        
                        // Divider
                        Divider()
                        
                        // Total Amount and Reset Button
                        HStack {
                            TotalAmountView(convertedAmount: convertedAmount, selectedCurrency: currencies[selectedCurrencyIndex])
                            Spacer()
                            ResetButton(euroAmount: $euroAmount,
                                        customExchangeRate: $customExchangeRate,
                                        selectedCurrencyIndex: $selectedCurrencyIndex,
                                        selectedRateCurrencyIndex: $selectedRateCurrencyIndex,
                                        showAllConversions: $showAllConversions)
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        if showAllConversions {
                            VStack(alignment: .leading, spacing: 8) {
                                CurrencyConversionListView(conversions: allCurrencyConversions)
                            }
                            .padding(.bottom, 30)
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 0.8))
                        } else {
                            AutomaticExchangeRatesView(automaticExchangeRates: automaticExchangeRates, selectedCurrency: currencies[selectedRateCurrencyIndex])
                                .transition(.slide)
                                .animation(.easeInOut)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(minHeight: geometry.size.height)
                .padding(.bottom, keyboard.currentHeight)
                .animation(.easeOut(duration: 0.6))
                .edgesIgnoringSafeArea(.bottom)
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













