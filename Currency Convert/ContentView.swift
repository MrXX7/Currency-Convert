//
//  ContentView.swift
//  Currency Convert
//
//  Created by Oncu Can on 26.01.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var isDarkMode = false

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
                        Label("Flags", systemImage: "flag.circle")
                    }
            }
            
            Spacer()
            
            // Footer Text (outside of TabView)
            Text("© 2023 Öncü Can. All rights reserved.")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}


#Preview {
    ContentView()
}
