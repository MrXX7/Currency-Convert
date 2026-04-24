//
//  CurrencyPickerView.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import SwiftUI

struct CurrencyPickerView: View {
    let title: String
    let subtitle: String
    let currencies: [CurrencyDefinition]
    @Binding var selectedCurrencyCode: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 94), spacing: 10)], spacing: 10) {
                ForEach(currencies) { currency in
                    Button {
                        selectedCurrencyCode = currency.code
                    } label: {
                        VStack(spacing: 6) {
                            Text(currency.flag)
                                .font(.title2)
                            Text(currency.code)
                                .font(.subheadline.weight(.semibold))
                            Text(currency.symbol)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(CurrencyChipButtonStyle(isSelected: selectedCurrencyCode == currency.code))
                }
            }
        }
    }
}

private struct CurrencyChipButtonStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isSelected ? Color.white : Color.primary)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(isSelected ? DesignPalette.accentStrong : DesignPalette.elevatedSurface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(isSelected ? DesignPalette.accentStrong : DesignPalette.stroke.opacity(0.9), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.18), value: configuration.isPressed)
    }
}
