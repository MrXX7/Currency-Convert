//
//  QuickAmountButtonsView.swift
//  Currency Convert
//
//  Created by Oncu Can on 12.06.2024.
//

import SwiftUI
import Foundation

struct QuickAmountButtonsView: View {
    @Environment(\.colorScheme) var colorScheme
    var quickAmounts: [String]
    @Binding var euroAmount: String

    var body: some View {
        HStack {
            ForEach(quickAmounts, id: \.self) { amount in
                Button(action: {
                    euroAmount = amount
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }) {
                    Text("\(amount)")
                        .frame(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.height / 32)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .background(Color(.gray).opacity(0.1))
                        .cornerRadius(10)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
