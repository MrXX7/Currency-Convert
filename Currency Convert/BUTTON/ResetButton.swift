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
    @Binding var selectedCurrencyIndex: Int
    @Binding var selectedRateCurrencyIndex: Int
    @Binding var showAllConversions: Bool
    
    // Animation state for the button icon
    @State private var isAnimating = false
    // State to show checkmark after reset
    @State private var showCheckmark = false
    
    var body: some View {
        Button(action: {
            // Reset variables
            euroAmount = ""
            customExchangeRate = ""
            selectedCurrencyIndex = 0
            selectedRateCurrencyIndex = 0
            showAllConversions = false
            
            // Haptic feedback
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
            // Trigger animation
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                isAnimating = true
            }
            
            // Show checkmark and reset animations after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                isAnimating = false
                withAnimation(.easeInOut(duration: 0.3)) {
                    showCheckmark = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Show checkmark for 1 second
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showCheckmark = false
                    }
                }
            }
        }) {
            HStack(spacing: 12) {
                // Icon changes based on showCheckmark state
                Image(systemName: showCheckmark ? "checkmark.circle.fill" : "arrow.counterclockwise.circle.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(showCheckmark ? .green : (isAnimating ? Color.accentColor : Color.secondary)) // Green for checkmark
                    .rotationEffect(.degrees(isAnimating ? 360 : 0)) // Rotation animation
                
                Text(showCheckmark ? "Done!" : "Reset") // Text changes to "Done!"
                    .font(.headline.weight(.medium))
                    .foregroundColor(Color.primary) // Dynamic text color
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 28)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(UIColor.systemGray6)) // Light gray background
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4) // Soft shadow
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.accentColor.opacity(0.5), lineWidth: 2) // Accent color border
            )
            .scaleEffect(isAnimating ? 1.05 : 1.0) // Slight grow animation
        }
        .buttonStyle(PlainButtonStyle()) // Override default style
    }
}

