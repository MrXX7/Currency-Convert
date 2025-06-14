//
//  DarkModeToggleButton.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import SwiftUI

struct DarkModeToggleButton: View {
    @Binding var isDarkMode: Bool
    
    var body: some View {
        Button(action: {
            // Toggle dark mode state with animation
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                isDarkMode.toggle()
            }
            // Add haptic feedback for user interaction
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }) {
            HStack {
                // Dynamically change icon based on dark mode state
                Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                    .font(.title2) // Slightly larger icon
                    .foregroundColor(isDarkMode ? .yellow : .orange) // Yellow for moon, orange for sun
                    .symbolRenderingMode(.multicolor) // For multi-color symbols (e.g., sun.max.fill)
                    .rotationEffect(.degrees(isDarkMode ? 360 : 0)) // Spin animation on toggle
                
                Text(isDarkMode ? "Dark Mode" : "Light Mode")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary) // Adapts to light/dark mode
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 18)
            .background(
                RoundedRectangle(cornerRadius: 15) // Rounded background
                    .fill(Color(UIColor.systemGray5)) // Neutral background color
                    .shadow(color: Color.black.opacity(isDarkMode ? 0.2 : 0.1),
                            radius: isDarkMode ? 8 : 4,
                            x: 0,
                            y: isDarkMode ? 4 : 2) // Dynamic shadow based on mode
            )
            .scaleEffect(isDarkMode ? 1.05 : 1.0) // Slight grow effect when dark mode is active
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isDarkMode) // Animation for scale effect
        }
        .buttonStyle(PlainButtonStyle()) // Ensure no default button styling interferes
    }
}


