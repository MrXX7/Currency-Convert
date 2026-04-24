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
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Manual Rate")
                    .font(.headline)
                    .foregroundStyle(DesignPalette.ink)
                Spacer()
                Text("Optional")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(DesignPalette.mutedInk)
            }

            TextField("Override 1 \(targetCurrency) rate", text: $customExchangeRate)
                .keyboardType(.decimalPad)
                .textFieldStyle(.plain)
                .focused($isFocused)
                .foregroundStyle(DesignPalette.ink)
                .padding(16)
                .background(DesignPalette.elevatedSurfaceStrong, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(DesignPalette.stroke.opacity(0.9), lineWidth: 1)
                )
                .shadow(color: DesignPalette.shadow, radius: 10, x: 0, y: 4)
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
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            isFocused = false
                        }
                    }
                }
        }
    }
}
