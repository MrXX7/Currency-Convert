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
    @Binding var isDarkMode: Bool
    @State private var exchangeRates: [String: Double] = [:]
    @State private var selectedRateCurrencyIndex = 0

    let currencies = ["EUR", "USD", "GBP", "TRY", "CAD", "CHF", "SAR", "AUD", "CNY"]
    let flags: [String: String] = ["EUR": "🇪🇺","USD": "🇺🇸", "GBP": "🇬🇧", "TRY": "🇹🇷", "CAD": "🇨🇦", "CHF": "🇨🇭", "SAR": "🇸🇦", "AUD": "🇦🇺", "CNY": "🇨🇳"]

    var body: some View {
        let convertedAmount = AmountConverter.convertAmount(euroAmount: euroAmount, customExchangeRate: customExchangeRate, selectedCurrencyIndex: selectedCurrencyIndex, exchangeRates: exchangeRates, currencies: currencies)
        
        let automaticExchangeRates = AutomaticExchangeRatesGenerator.generateRates(currencies: currencies, exchangeRates: exchangeRates, flags: flags, baseCurrency: currencies[selectedRateCurrencyIndex])
        
        return VStack {
            HStack {
                Spacer()
                DarkModeToggleButton(isDarkMode: $isDarkMode)
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            
            AmountInputView(euroAmount: $euroAmount)
            CurrencyPickerView(currencies: currencies, selectedCurrencyIndex: $selectedCurrencyIndex)
            if selectedCurrencyIndex != 0 { // Show exchange rate input if not EUR
                ExchangeRateInputView(customExchangeRate: $customExchangeRate)
            }
            HStack {
                TotalAmountView(convertedAmount: convertedAmount, selectedCurrency: currencies[selectedCurrencyIndex])
                ResetButton(euroAmount: $euroAmount, customExchangeRate: $customExchangeRate)
            }
            Divider()
                .padding()
            
            ExchangeRatePickerView(currencies: currencies, selectedRateCurrencyIndex: $selectedRateCurrencyIndex)
            
            AutomaticExchangeRatesView(automaticExchangeRates: automaticExchangeRates, selectedCurrency: currencies[selectedRateCurrencyIndex])
            
            Text("© 2023 Öncü Can. All rights reserved.")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
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
}



