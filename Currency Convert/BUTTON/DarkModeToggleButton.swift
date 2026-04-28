//
//  DarkModeToggleButton.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import SwiftUI
import UIKit

struct DarkModeToggleButton: View {
    @Binding var isDarkMode: Bool

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                isDarkMode.toggle()
            }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            Label(isDarkMode ? "Dark" : "Light", systemImage: isDarkMode ? "moon.stars.fill" : "sun.max.fill")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .background(DesignPalette.ink.opacity(0.34), in: Capsule())
                .overlay(
                    Capsule()
                        .stroke(DesignPalette.accentSoft.opacity(0.35), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}
