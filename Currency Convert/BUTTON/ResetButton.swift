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
    @Binding var showAllConversions: Bool

    var body: some View {
        Button(action: {
            euroAmount = ""
            customExchangeRate = ""
            selectedCurrencyIndex = 0
            selectedRateCurrencyIndex = 0
            showAllConversions = false 
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }) {
            HStack {
                Image(systemName: "arrow.counterclockwise.circle.fill")
                Text("Reset")
                    .foregroundColor(.blue)
            }
        }
    }
}

