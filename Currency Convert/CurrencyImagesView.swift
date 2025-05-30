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
        NavigationView { // Wrap your view inside a NavigationView
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
                                    // Center the flag and increase the size
                                    Text(flags[currency] ?? "")
                                        .font(.system(size: 70)) // Increased size for flags
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding()
                                        .background(Color.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 10)) // Optional background
                                        .scaleEffect(1.0) // Initial scale
                                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: true) // Apply spring animation on tap
                                        .simultaneousGesture(
                                            TapGesture()
                                                .onEnded { _ in
                                                    // Trigger a subtle haptic feedback
                                                    let generator = UIImpactFeedbackGenerator(style: .light)
                                                    generator.impactOccurred()
                                                }
                                        )
                                }
                                
                                // Display the country name below the flag
                                Text(currency)
                                    .font(.subheadline)
                                    .padding(.top, 5)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Currency Flags") // Add a navigation title
        }
    }
}


#Preview {
    CurrencyImagesView()
}

