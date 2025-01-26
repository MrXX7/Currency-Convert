//
//  CurrencyImagesView.swift
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
        NavigationView {
            VStack {
                Text("Currency Flags")
                    .font(.title)
                    .padding()

                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                        ForEach(currencies, id: \.self) { currency in
                            NavigationLink(
                                destination: CurrencyFlagDetailView(currency: currency, flag: flags[currency] ?? ""),
                                label: {
                                    VStack {
                                        Text(flags[currency] ?? "")
                                            .font(.system(size: 50))
                                        Text(currency)
                                            .font(.subheadline)
                                            .padding(.top, 5)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .center)
                                }
                            )
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Currency Flags", displayMode: .inline)
        }
    }
}


#Preview {
    CurrencyImagesView()
}
