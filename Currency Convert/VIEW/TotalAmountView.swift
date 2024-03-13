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

    @State private var animatedConvertedAmount: Double = 0

    var body: some View {
        HStack {
            Text("Total Amount: \(animatedConvertedAmount, specifier: "%.2f") \(selectedCurrency)")
                .padding(.vertical)
                .font(.title2)
                .onAppear {
                    // İlk kez göründüğünde animasyonu başlat
                    withAnimation(.spring()) {
                        animatedConvertedAmount = convertedAmount
                    }
                }
                .onChange(of: convertedAmount) { newValue in
                    // Değer değiştiğinde animasyonu başlat
                    withAnimation(.spring()) {
                        animatedConvertedAmount = newValue
                    }
                }
//                .scaleEffect(animatedConvertedAmount == 0 ? 0.5 : 1.0) Animasyon sırasında metni küçült
            Spacer()
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}


