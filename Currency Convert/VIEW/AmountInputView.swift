//
//  AmountInputView.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import SwiftUI

struct AmountInputView: View {
    @Binding var amountInput: String
    let currency: CurrencyDefinition
    @FocusState.Binding var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Amount")
                .font(.headline)

            HStack(alignment: .firstTextBaseline, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(currency.code)
                        .font(.headline.weight(.semibold))
                    Text(currency.name)
                        .font(.caption)
                        .foregroundStyle(DesignPalette.mutedInk)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(DesignPalette.accentSoft.opacity(0.75), in: RoundedRectangle(cornerRadius: 16, style: .continuous))

                TextField("0.00", text: $amountInput)
                    .keyboardType(.decimalPad)
                    .focused($isFocused)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.trailing)
                    .foregroundStyle(DesignPalette.ink)
            }
            .padding(16)
            .background(DesignPalette.elevatedSurface, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(DesignPalette.stroke.opacity(0.9), lineWidth: 1)
            )
        }
    }
}
