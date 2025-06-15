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
                    .font(.title3) // İkon boyutunu küçülttük
                    .foregroundColor(isDarkMode ? .yellow : .orange)
                    .symbolRenderingMode(.multicolor)
                    .rotationEffect(.degrees(isDarkMode ? 360 : 0))
                
                Text(isDarkMode ? "Dark Mode" : "Light Mode")
                    .font(.subheadline) // Metin boyutunu küçülttük
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            .padding(.vertical, 8) // Dikey dolguyu biraz küçülttük
            .padding(.horizontal, 14) // Yatay dolguyu belirgin şekilde küçülttük
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(UIColor.systemGray5))
                    .shadow(color: Color.black.opacity(isDarkMode ? 0.2 : 0.1),
                            radius: isDarkMode ? 8 : 4,
                            x: 0,
                            y: isDarkMode ? 4 : 2)
            )
            .scaleEffect(isDarkMode ? 1.05 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isDarkMode)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

