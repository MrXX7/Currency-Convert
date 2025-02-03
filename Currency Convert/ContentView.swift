//
//  ContentView.swift
//  Currency Convert
//
//  Created by Oncu Can on 26.01.2025.
//

import SwiftUI

struct ContentView: View {
    @Binding var isDarkModee: Bool
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
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
        .edgesIgnoringSafeArea(.all)
        .animation(.easeInOut(duration: 0.5), value: isDarkModee)
        .preferredColorScheme(isDarkModee ? .dark : .light)
        .environment(\.sizeCategory, .large)    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(isDarkModee: .constant(true))
                .previewDevice("iPhone SE (3rd generation)")
            
            ContentView(isDarkModee: .constant(true))
                .previewDevice("iPhone 16 Pro")
            
            ContentView(isDarkModee: .constant(true))
                .previewDevice("iPad Pro (12.9-inch) (6th generation)")
        }
    }
}

