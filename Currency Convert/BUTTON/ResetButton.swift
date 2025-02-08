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
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isAnimating = true
            }
            
            // Animasyonu sıfırla
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isAnimating = false
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: "arrow.counterclockwise.circle.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isAnimating ? Color.secondary : Color.primary) // Dinamik renk
                    .rotationEffect(.degrees(isAnimating ? 360 : 0)) // Dönme animasyonu
                
                Text("Reset")
                    .font(.headline)
                    .foregroundColor(Color.primary) // Dinamik metin rengi
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.systemGray5)) // Açık gri arka plan
                    .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4) // Hafif gölge
            )
            .scaleEffect(isAnimating ? 1.1 : 1.0) // Büyüme animasyonu
        }
        .buttonStyle(PlainButtonStyle()) // Varsayılan stilin üzerine yaz
    }
}

