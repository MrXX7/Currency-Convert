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
        VStack {
            TabView {
                // First Tab (Currency Converter)
                CurrencyConvertView(isDarkMode: $isDarkModee)
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
        .animation(.easeInOut(duration: 0.5), value: isDarkModee)
        .preferredColorScheme(isDarkModee ? .dark : .light) // Burada preferredColorScheme kullanın
    }
}

