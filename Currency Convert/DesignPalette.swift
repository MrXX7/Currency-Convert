//
//  DesignPalette.swift
//  Currency Convert
//
//  Created by OpenAI Codex.
//

import SwiftUI

enum DesignPalette {
    static let canvasTop = Color(red: 0.71, green: 0.85, blue: 0.97)
    static let canvasBottom = Color(red: 0.95, green: 0.98, blue: 1.00)
    static let ink = Color(red: 0.12, green: 0.24, blue: 0.36)
    static let mutedInk = Color(red: 0.39, green: 0.53, blue: 0.67)
    static let surface = Color(red: 0.96, green: 0.99, blue: 1.00)
    static let elevatedSurface = Color(red: 0.90, green: 0.96, blue: 0.99)
    static let stroke = Color(red: 0.76, green: 0.87, blue: 0.95)
    static let accent = Color(red: 0.38, green: 0.70, blue: 0.96)
    static let accentStrong = Color(red: 0.20, green: 0.49, blue: 0.79)
    static let accentSoft = Color(red: 0.81, green: 0.92, blue: 0.99)
    static let success = Color(red: 0.18, green: 0.62, blue: 0.54)

    static let heroGradient = LinearGradient(
        colors: [
            Color(red: 0.56, green: 0.79, blue: 0.96),
            Color(red: 0.73, green: 0.89, blue: 0.99),
            Color(red: 0.94, green: 0.98, blue: 1.00)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let libraryGradient = LinearGradient(
        colors: [
            Color(red: 0.49, green: 0.76, blue: 0.96),
            Color(red: 0.79, green: 0.92, blue: 1.00)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
