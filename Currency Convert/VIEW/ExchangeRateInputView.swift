//
//  ExchangeRateInputView.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import SwiftUI

struct ExchangeRateInputView: View {
    @Binding var customExchangeRate: String

    var body: some View {
        HStack {
            Text("Exchange Rate:")
                .font(.title2)
            TextField("Enter Rate", text: $customExchangeRate)
                .font(.title2)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
        }
        .padding(.vertical, 8)
        .onTapGesture {
            UIApplication.shared.windows.first?.endEditing(true)
        }
    }
}



