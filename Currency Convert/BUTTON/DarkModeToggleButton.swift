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
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                isDarkMode.toggle()
            }
        } label: {
            Label(isDarkMode ? "Dark" : "Light", systemImage: isDarkMode ? "moon.stars.fill" : "sun.max.fill")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .background(.white.opacity(0.16), in: Capsule())
                .overlay(
                    Capsule()
                        .stroke(.white.opacity(0.22), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}
