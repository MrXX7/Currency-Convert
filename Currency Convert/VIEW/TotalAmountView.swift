//
//  TotalAmountView.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import SwiftUI

struct TotalAmountView: View {
    var convertedAmount: Double
    var selectedCurrency: String
    @Binding var isDarkMode: Bool
    
    var body: some View {
        Text("\(convertedAmount, specifier: "%.2f") \(selectedCurrency)")
            .font(.title)
            .fontWeight(.medium)
            .foregroundColor(convertedAmount >= 0 ? .green : .red)
            .padding(8)
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .shadow(radius: 3)
            .transition(.scale) // Animasyon ekle
            .animation(.easeInOut(duration: 0.5), value: isDarkMode)
        
    }
}



