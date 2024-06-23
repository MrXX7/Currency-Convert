//
//  ResetButton.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import SwiftUI

struct ResetButton: View {
    @Binding var euroAmount: String
    @Binding var customExchangeRate: String
    @Binding var selectedCurrencyIndex: Int
    @Binding var selectedRateCurrencyIndex: Int

    var body: some View {
        Button(action: {
            euroAmount = ""
            customExchangeRate = ""
            selectedCurrencyIndex = 0
            selectedRateCurrencyIndex = 0
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }) {
            HStack {
                Text("Reset")
                Image(systemName: "arrow.counterclockwise.circle.fill")
                    .foregroundColor(Color(.systemOrange))
//                    .padding()
            }
        }
    }
}

