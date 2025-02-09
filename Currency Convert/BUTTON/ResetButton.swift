//
//  ResetButton.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import SwiftUI

struct ResetButton: View {
    @Binding var euroAmount: String
    @Binding var customExchangeRate: String
    @Binding var selectedCurrencyIndex: Int
    @Binding var selectedRateCurrencyIndex: Int
    @Binding var showAllConversions: Bool
    
    // Animasyon durumu
    @State private var isAnimating = false
    
    var body: some View {
        Button(action: {
            // Değişkenleri sıfırla
            euroAmount = ""
            customExchangeRate = ""
            selectedCurrencyIndex = 0
            selectedRateCurrencyIndex = 0
            showAllConversions = false
            
            // Dokunmatik geri bildirim
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
            // Animasyon tetikle
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                isAnimating = true
            }
            
            // Animasyonu sıfırla
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                isAnimating = false
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: "arrow.counterclockwise.circle.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(isAnimating ? Color.accentColor : Color.secondary) // Animasyon sırasında renk değişimi
                    .rotationEffect(.degrees(isAnimating ? 360 : 0)) // Dönme animasyonu
                
                Text("Reset")
                    .font(.headline.weight(.medium))
                    .foregroundColor(Color.primary) // Dinamik metin rengi
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 28)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(UIColor.systemGray6)) // Açık gri arka plan
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4) // Yumuşak gölge
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.accentColor.opacity(0.5), lineWidth: 2) // Vurgulu kenarlık
            )
            .scaleEffect(isAnimating ? 1.05 : 1.0) // Hafif büyüme animasyonu
        }
        .buttonStyle(PlainButtonStyle()) // Varsayılan stilin üzerine yaz
    }
}

