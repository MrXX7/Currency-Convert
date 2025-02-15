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
            Text("Custom Exchange Rate:")
                .font(.footnote)
            
            HStack {
                TextField("Enter Rate", text: $customExchangeRate)
                    .font(.headline)
                    .keyboardType(.decimalPad)
                    .onChange(of: customExchangeRate) { newValue in
                        // Sayılar, nokta ve virgüle izin ver
                        let filtered = newValue.filter { "0123456789.,".contains($0) }
                        if filtered != newValue {
                            customExchangeRate = filtered
                        }
                        // Maksimum 1 adet nokta veya virgül kontrolü
                        let decimalCount = filtered.filter({ $0 == "." || $0 == "," }).count
                        if decimalCount > 1 {
                            if let firstDecimal = filtered.first(where: { $0 == "." || $0 == "," }) {
                                let upToDecimal = String(filtered.prefix(while: { $0 != "." && $0 != "," }))
                                customExchangeRate = upToDecimal + String(firstDecimal)
                            }
                        }
                        // Maksimum 10 karakter sınırı
                        if filtered.count > 10 {
                            customExchangeRate = String(filtered.prefix(10))
                        }
                    }
                
                if !customExchangeRate.isEmpty {
                    Button(action: {
                        customExchangeRate = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3))
            )
        }
        .padding(.vertical, 8)
        .onTapGesture {
            UIApplication.shared.windows.first?.endEditing(true)
        }
    }
}



