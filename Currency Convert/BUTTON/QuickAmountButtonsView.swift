//
//  QuickAmountButtonsView.swift
//  Currency Convert
//
//  Created by Oncu Can on 12.06.2024.
//

import SwiftUI
import Foundation

struct QuickAmountButtonStyle: ButtonStyle {
    // Indicates if the button is currently selected.
    var isSelected: Bool
    // Determines if dark mode is active for appropriate color adjustments.
    var isDarkMode: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .medium)) // Slightly increase font size and weight
            .padding(.vertical, 10) // Increase vertical padding
            .padding(.horizontal, 16) // Increase horizontal padding
            .background(
                RoundedRectangle(cornerRadius: 15) // Use a slightly larger corner radius
                    .fill(isSelected ? (isDarkMode ? Color.accentColor.opacity(0.8) : Color.accentColor) : Color(UIColor.systemGray5)) // Adjust background color for better contrast
            )
            .foregroundColor(isSelected ? .white : (isDarkMode ? .white.opacity(0.8) : .black.opacity(0.8))) // Text color based on selection and dark mode
            .overlay(
                // Add a subtle border when selected
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? (isDarkMode ? Color.white.opacity(0.3) : Color.white.opacity(0.5)) : Color.clear, lineWidth: isSelected ? 1.5 : 0)
            )
            .shadow(color: isSelected ? Color.black.opacity(0.2) : Color.black.opacity(0.08),
                    radius: isSelected ? 6 : 3, // Increase shadow radius for selected state
                    x: 0,
                    y: isSelected ? 4 : 2) // Adjust shadow offset
            .scaleEffect(configuration.isPressed ? 0.95 : 1) // Scale down slightly when pressed
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed) // Smooth spring animation for press
            .animation(.easeInOut(duration: 0.2), value: isSelected) // Smooth transition for selection state
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
