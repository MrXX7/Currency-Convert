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

        return GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 15) { // Boşluğu azaltmak için buradaki değeri düşürdüm
                    HStack {
                        Spacer()
                        DarkModeToggleButton(isDarkMode: $isDarkMode)
                    }
                    .preferredColorScheme(isDarkMode ? .dark : .light)
                    
                    QuickAmountPickerView(quickAmounts: quickAmounts, euroAmount: $euroAmount)
                    AmountInputView(euroAmount: $euroAmount)
                    CurrencyPickerView(currencies: currencies, selectedCurrencyIndex: $selectedCurrencyIndex)
                    ExchangeRateInputView(customExchangeRate: $customExchangeRate)
                    
                    HStack {
                        TotalAmountView(convertedAmount: convertedAmount, selectedCurrency: currencies[selectedCurrencyIndex])
                        ResetButton(euroAmount: $euroAmount, customExchangeRate: $customExchangeRate, selectedCurrencyIndex: $selectedCurrencyIndex, selectedRateCurrencyIndex: $selectedRateCurrencyIndex)
                    }
                    Divider()
                        .padding(.vertical, 10) // Divider öncesi ve sonrası boşlukları düşürdüm
                    
                    ExchangeRatePickerView(currencies: currencies, selectedRateCurrencyIndex: $selectedRateCurrencyIndex)
                    
                    AutomaticExchangeRatesView(automaticExchangeRates: automaticExchangeRates, selectedCurrency: currencies[selectedRateCurrencyIndex])
                    
                    Text("© 2023 Öncü Can. All rights reserved.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(minWidth: geometry.size.width * 0.9) // Ekran genişliğinin %90'ını kullanarak sol ve sağ boşlukları dengeledim
                .frame(minHeight: geometry.size.height)
                .padding(.bottom, keyboard.currentHeight) // Klavye yüksekliğine göre alt boşluk ekledim
                .animation(.easeOut(duration: 0.16)) // Geçiş için animasyon ekledim
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
}







