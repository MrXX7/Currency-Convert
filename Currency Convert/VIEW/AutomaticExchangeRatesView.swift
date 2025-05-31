//
//  AutomaticExchangeRatesView.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import SwiftUI

struct AutomaticExchangeRatesView: View {
    @Environment(\.colorScheme) var colorScheme // Accesses the current color scheme (light/dark)
    var automaticExchangeRates: [String] // Array of formatted exchange rate strings (e.g., "🇪🇺 = 1.0000 EUR")
    var selectedCurrency: String // The base currency for which rates are displayed (e.g., "EUR")
    
    // Defines a grid with two flexible columns
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 15) { // Increased spacing for better visual separation
            Text("\(selectedCurrency) Exchange Rates")
                .font(.title2) // Slightly larger and more prominent title
                .fontWeight(.bold) // Bold font for the title
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .padding(.bottom, 5) // Padding below the title
            
            // Display rates in a two-column grid
            LazyVGrid(columns: columns, spacing: 10) { // Grid for two columns
                ForEach(automaticExchangeRates, id: \.self) { rate in
                    Text(rate)
                        .font(.subheadline) // Consistent font size
                        .foregroundColor(colorScheme == .dark ? .gray : .black)
                        .frame(maxWidth: .infinity, alignment: .leading) // Ensure left alignment in grid cell
                }
            }
            .padding(.horizontal) // Add horizontal padding for the grid content
            
            Spacer() // Pushes content to the top
        }
        .padding(.leading, 10) // Overall leading padding for the VStack
        .onTapGesture {
            // Dismiss keyboard when tapping anywhere on this view
            UIApplication.shared.windows.first?.endEditing(true)
        }
    }
}








