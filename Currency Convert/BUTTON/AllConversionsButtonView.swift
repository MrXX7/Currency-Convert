//
//  AllConversionsButtonView.swift
//  Currency Convert
//
//  Created by Oncu Can on 1.10.2024.
//

import SwiftUI

struct AllConversionsButtonView: View {
    @Binding var showAllConversions: Bool
    @Binding var euroAmount: String // Amount entered by the user
    @Environment(\.colorScheme) var colorScheme // Accesses the current color scheme
    
    var body: some View {
        Button(action: {
            // Toggle the showAllConversions state with animation
            withAnimation {
                showAllConversions.toggle()
            }
            // Add haptic feedback for user interaction
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }) {
            HStack {
                // Dynamically change the icon based on showAllConversions state
                Image(systemName: showAllConversions ? "eye.slash.fill" : "eye.fill") // Icon for hide/show
                    .font(.system(size: 14))
                
                // Dynamically change the text based on showAllConversions state
                Text(showAllConversions ? "Hide All Conversions" : "Show All Conversions")
                    .font(.system(size: 14))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 15)
            .background(
                // Dynamic background color based on selection and dark mode
                showAllConversions ?
                    (colorScheme == .dark ? Color.blue.opacity(0.7) : Color.blue) :
                    Color(UIColor.systemGray6)
            )
            .foregroundColor(showAllConversions ? .white : (colorScheme == .dark ? .white : .black))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            // Visually indicate disabled state when euroAmount is empty
            .opacity(euroAmount.isEmpty ? 0.4 : 1) // Reduce opacity for disabled state
            .scaleEffect(euroAmount.isEmpty ? 0.95 : 1.0) // Slightly scale down when disabled
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: euroAmount.isEmpty) // Animation for disabled state
        }
        .disabled(euroAmount.isEmpty) // Disable button when euroAmount is empty
    }
}
