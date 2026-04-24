//
//  ContentView.swift
//  Currency Convert
//
//  Created by Oncu Can on 26.01.2025.
//

import SwiftUI

struct ContentView: View {
    @Binding var isDarkModee: Bool

    var body: some View {
        TabView {
            CurrencyConvertView(isDarkMode: $isDarkModee)
                .tabItem {
                    Label("Convert", systemImage: "arrow.left.arrow.right.circle.fill")
                }

            CurrencyImagesView()
                .tabItem {
                    Label("Library", systemImage: "rectangle.stack.fill")
                }
        }
        .preferredColorScheme(isDarkModee ? .dark : .light)
    }
}

#Preview("Light") {
    ContentView(isDarkModee: .constant(false))
}

#Preview("Dark") {
    ContentView(isDarkModee: .constant(true))
}
