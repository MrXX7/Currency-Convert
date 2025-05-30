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
    
    // State to trigger animation on amount change
    @State private var animateAmount: Bool = false
    
    var body: some View {
        Text("\(convertedAmount, specifier: "%.2f") \(selectedCurrency)")
            .font(.title)
            .fontWeight(.medium)
            .foregroundColor(convertedAmount >= 0 ? .green : .red)
            .padding(8)
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .shadow(radius: 3)
            // Apply scale effect based on animation state
            .scaleEffect(animateAmount ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: animateAmount)
            .animation(.easeInOut(duration: 0.5), value: isDarkMode)
            .onChange(of: convertedAmount) { _ in
                // Toggle animateAmount to trigger the animation
                animateAmount = true
                // Reset animateAmount after a short delay to allow re-triggering
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    animateAmount = false
                }
            }
    }
}



