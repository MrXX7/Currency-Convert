//
//  AmountInputView.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import SwiftUI

struct AmountInputView: View {
    @Binding var euroAmount: String
    @FocusState private var isAmountInputFocused: Bool

    var body: some View {
        VStack {
            TextField("Enter amount in EUR", text: $euroAmount)
                .keyboardType(.decimalPad)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                .focused($isAmountInputFocused) // TextField'ı isAmountInputFocused ile ilişkilendirir
                // .onAppear { // Bu blok artık yok
                //    isAmountInputFocused = true // Bu satır artık yok
                // }
                .onChange(of: euroAmount) { newValue in
                    // Ensure only valid decimal numbers are entered
                    let filtered = newValue.filter { "0123456789.,".contains($0) }
                    if filtered != newValue {
                        euroAmount = filtered
                    }
                    // Allow only one decimal separator
                    let decimalCount = newValue.filter { $0 == "." || $0 == "," }.count
                    if decimalCount > 1 {
                        euroAmount = String(newValue.dropLast())
                    }
                }
        }
        .padding(.horizontal)
    }
}


