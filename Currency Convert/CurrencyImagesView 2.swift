//
//  CurrencyImagesView 2.swift
//  Currency Convert
//
//  Created by Oncu Can on 26.01.2025.
//


import SwiftUI

struct CurrencyImagesView: View {
    let currencies = ["EUR", "USD", "GBP", "TRY", "CAD", "CHF", "SAR", "AUD", "CNY"]
    let flags: [String: String] = [
        "EUR": "🇪🇺", "USD": "🇺🇸", "GBP": "🇬🇧", "TRY": "🇹🇷", "CAD": "🇨🇦",
        "CHF": "🇨🇭", "SAR": "🇸🇦", "AUD": "🇦🇺", "CNY": "🇨🇳"
    ]
    
    var body: some View {
        VStack {
            Text("Currency Flags")
                .font(.title)
                .padding()

            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                    ForEach(currencies, id: \.self) { currency in
                        VStack {
                            Text(flags[currency] ?? "")
                                .font(.system(size: 50))
                            Text(currency)
                                .font(.subheadline)
                                .padding(.top, 5)
                            
                            // NavigationLink for Currency Details
                            NavigationLink(destination: CurrencyFlagDetailView(currency: currency, flagImageNames: [currency + "Flag", currency.lowercased() + "1", currency.lowercased() + "2", currency.lowercased() + "3"])) {
                                Text("View \(currency) Details")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                    .padding(.top, 5)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .padding()
            }
        }
    }
}
