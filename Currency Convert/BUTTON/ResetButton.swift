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

    var body: some View {
        Button(action: {
            // Reset işlemi burada gerçekleşecek.
            euroAmount = ""
            customExchangeRate = ""
        }) {
            Image(systemName: "arrow.counterclockwise.circle.fill")
                .foregroundColor(Color(.systemOrange)) // Alternatif olarak turuncu bir renk
                .padding()
        }
    }
}
