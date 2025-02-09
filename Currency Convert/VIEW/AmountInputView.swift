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
        HStack {
            TextField("Enter Amount", text: $euroAmount)
                .keyboardType(.decimalPad)
                .font(.headline)
                .onTapGesture {
                    UIApplication.shared.windows.first?.endEditing(true)
                }
            
            if !euroAmount.isEmpty {
                Button(action: {
                    euroAmount = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(height: 35) // Yükseklik ekledim
        .frame(maxWidth: .infinity) // Genişlik ekledim
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3))
        )
    }
}


