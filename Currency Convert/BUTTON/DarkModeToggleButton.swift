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
            isDarkMode.toggle()
            let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
        }) {
            Image(systemName: isDarkMode ? "moon.fill" : "moon")
                .foregroundColor(isDarkMode ? .blue : .yellow)
                .padding()
        }
    }
}

