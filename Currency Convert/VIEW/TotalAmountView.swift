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
                    withAnimation(.spring()) {
                        animatedConvertedAmount = convertedAmount
                    }
                }
                .onChange(of: convertedAmount) { newValue in
                    withAnimation(.spring()) {
                        animatedConvertedAmount = newValue
                    }
                }
            Spacer()
        }
        .onTapGesture {
            UIApplication.shared.windows.first?.endEditing(true)
        }
    }
}



