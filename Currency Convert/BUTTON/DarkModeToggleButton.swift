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
            Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                .font(.system(size: 18))
                .foregroundColor(isDarkMode ? .yellow : .blue)
                .padding(8)
                .background(Color(UIColor.systemGray6).opacity(0.6))
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
    }
}


