//
//  ContentView.swift
//  Currency Convert
//
//  Created by Oncu Can on 26.01.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var isDarkMode = false
    @Binding var isDarkModee: Bool
    var body: some View {
        VStack {
            TabView {
                // First Tab (Currency Converter)
                CurrencyConvertView(isDarkMode: $isDarkMode)
                    .tabItem {
                        Label("Converter", systemImage: "dollarsign.circle")
                    }

                // Second Tab (Currency Flags)
                CurrencyImagesView()
                    .tabItem {
                        Label("Banknotes", systemImage: "note.text")
                    }
            }
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

