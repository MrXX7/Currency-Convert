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
        }) {
            Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                .font(.title)
                .foregroundColor(isDarkMode ? .yellow : .blue)
        }
    }
}


