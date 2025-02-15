//
//  QuickAmountButtonsView.swift
//  Currency Convert
//
//  Created by Oncu Can on 12.06.2024.
//

import SwiftUI
import Foundation

struct QuickAmountButtonStyle: ButtonStyle {
    var isSelected: Bool
    var isDarkMode: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(isSelected ? (isDarkMode ? Color.green.opacity(0.7) : Color.green) : Color(UIColor.systemGray6))
            .cornerRadius(12)
            .shadow(color: isSelected ? Color.black.opacity(0.15) : Color.black.opacity(0.05),
                    radius: isSelected ? 4 : 2,
                    x: 0,
                    y: isSelected ? 3 : 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(), value: configuration.isPressed)
    }
}

struct QuickAmountPickerView: View {
    let quickAmounts: [String]
    @Binding var euroAmount: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(quickAmounts, id: \.self) { amount in
                    Button(action: {
                        euroAmount = amount
                    }) {
                        Text(amount)
                            .foregroundColor(euroAmount == amount ? .white : (colorScheme == .dark ? .white : .black))
                            .frame(minWidth: 40)
                    }
                    .buttonStyle(QuickAmountButtonStyle(isSelected: euroAmount == amount,
                                                     isDarkMode: colorScheme == .dark))
                }
            }
            .padding(.vertical, 5)
        }
    }
}
