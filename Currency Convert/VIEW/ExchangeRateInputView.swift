//
//  ExchangeRateInputView.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import SwiftUI

struct ExchangeRateInputView: View {
    @Binding var customExchangeRate: String
    let targetCurrency: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Manual Rate")
                    .font(.headline)
                Spacer()
                Text("Optional")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(DesignPalette.mutedInk)
            }

            TextField("Override 1 \(targetCurrency) rate", text: $customExchangeRate)
                .keyboardType(.decimalPad)
                .textFieldStyle(.plain)
                .padding(16)
                .background(DesignPalette.elevatedSurface, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(DesignPalette.stroke.opacity(0.9), lineWidth: 1)
                )
                .overlay(alignment: .trailing) {
                    if !customExchangeRate.isEmpty {
                        Button {
                            customExchangeRate = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(DesignPalette.mutedInk)
                                .padding(.trailing, 14)
                        }
                    }
                }
        }
    }
}
