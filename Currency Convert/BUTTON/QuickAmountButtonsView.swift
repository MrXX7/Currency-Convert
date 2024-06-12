//
//  QuickAmountButtonsView.swift
//  Currency Convert
//
//  Created by Oncu Can on 12.06.2024.
//

import SwiftUI
import Foundation

struct QuickAmountButtonsView: View {
    var quickAmounts: [String]
    @Binding var euroAmount: String

    var body: some View {
        HStack {
            ForEach(quickAmounts, id: \.self) { amount in
                Button(action: {
                    euroAmount = amount
                }) {
                    Text(amount)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
