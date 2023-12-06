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

            // Apply Dark Mode
            if isDarkMode {
                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
            } else {
                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
            }
        }) {
            Image(systemName: isDarkMode ? "moon.fill" : "moon")
                .foregroundColor(isDarkMode ? .yellow : .blue)
                .padding()
        }
    }
}

