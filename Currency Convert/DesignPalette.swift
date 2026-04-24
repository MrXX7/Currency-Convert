//
//  DesignPalette.swift
//  Currency Convert
//
//  Created by OpenAI Codex.
//

import SwiftUI

enum DesignPalette {
    static let canvasTop = Color(red: 0.09, green: 0.13, blue: 0.20)
    static let canvasBottom = Color(red: 0.83, green: 0.80, blue: 0.72)
    static let ink = Color(red: 0.12, green: 0.15, blue: 0.21)
    static let mutedInk = Color(red: 0.35, green: 0.37, blue: 0.42)
    static let surface = Color(red: 0.97, green: 0.95, blue: 0.90)
    static let elevatedSurface = Color(red: 0.93, green: 0.90, blue: 0.84)
    static let stroke = Color(red: 0.78, green: 0.73, blue: 0.64)
    static let accent = Color(red: 0.73, green: 0.54, blue: 0.28)
    static let accentStrong = Color(red: 0.50, green: 0.33, blue: 0.14)
    static let accentSoft = Color(red: 0.89, green: 0.83, blue: 0.72)
    static let success = Color(red: 0.23, green: 0.46, blue: 0.34)

    static let heroGradient = LinearGradient(
        colors: [canvasTop, Color(red: 0.17, green: 0.22, blue: 0.31), Color(red: 0.40, green: 0.35, blue: 0.27)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let libraryGradient = LinearGradient(
        colors: [Color(red: 0.22, green: 0.26, blue: 0.35), Color(red: 0.55, green: 0.43, blue: 0.25)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
