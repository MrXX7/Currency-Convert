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
        NavigationView {  // Wrap your view inside a NavigationView
            VStack {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                        ForEach(currencies, id: \.self) { currency in
                            VStack {
                                // Wrap the flag image with NavigationLink
                                NavigationLink(destination: CurrencyFlagDetailView(currency: currency,
                                    flagImageNames: [
                                        currency + "Flag",
                                        currency.lowercased() + "1",
                                        currency.lowercased() + "2",
                                        currency.lowercased() + "3",
                                        currency.lowercased() + "4",
                                        currency.lowercased() + "5",
                                        currency.lowercased() + "6",
                                        currency.lowercased() + "7",
                                        currency.lowercased() + "8"
                                    ].filter { UIImage(named: $0) != nil } // Filter out invalid image names
                                )) {
                                    Text(flags[currency] ?? "") // Display the country flag as a clickable link
                                        .font(.system(size: 50))  // Set font size for the flag emoji
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding()
                                }


                                // Display the country name below the flag
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .padding()
                }

            }
        }
    }
}

#Preview {
    CurrencyImagesView()
}

