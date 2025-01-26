//
//  Currency_ConvertApp.swift
//  Currency Convert
//
//  Created by Oncu Can on 29.11.2023.
//

import SwiftUI

@main
struct Currency_ConvertApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = true
    
    var body: some Scene {
        WindowGroup {
//            CurrencyConvertView(isDarkMode: $isDarkMode)
//                .preferredColorScheme(isDarkMode ? .dark : .light)
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
