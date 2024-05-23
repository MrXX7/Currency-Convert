//
//  AmountInputView.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import SwiftUI

struct AmountInputView: View {
    @Binding var euroAmount: String

    var body: some View {
        TextField("Enter Amount", text: $euroAmount)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.decimalPad)
            .font(.title2)
            .onTapGesture {
                UIApplication.shared.windows.first?.endEditing(true)
            }
    }
}


