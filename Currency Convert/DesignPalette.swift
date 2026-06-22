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
    static let ink = Color(red: 0.07, green: 0.18, blue: 0.31)
    static let mutedInk = Color(red: 0.18, green: 0.33, blue: 0.52)
    static let surface = Color(red: 0.94, green: 0.97, blue: 0.99)
    static let elevatedSurface = Color(red: 0.86, green: 0.92, blue: 0.97)
    static let elevatedSurfaceStrong = Color(red: 0.77, green: 0.88, blue: 0.95)
    static let stroke = Color(red: 0.49, green: 0.64, blue: 0.79)
    static let accent = Color(red: 0.38, green: 0.70, blue: 0.96)
    static let accentStrong = Color(red: 0.20, green: 0.49, blue: 0.79)
    static let accentSoft = Color(red: 0.74, green: 0.88, blue: 0.98)
    static let success = Color(red: 0.18, green: 0.62, blue: 0.54)
    static let shadow = Color(red: 0.16, green: 0.34, blue: 0.54).opacity(0.16)

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
