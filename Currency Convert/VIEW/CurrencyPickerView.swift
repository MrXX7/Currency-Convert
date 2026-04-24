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
                .foregroundStyle(DesignPalette.ink)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(DesignPalette.mutedInk)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 108), spacing: 12)], spacing: 12) {
                ForEach(currencies) { currency in
                    Button {
                        selectedCurrencyCode = currency.code
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .center, spacing: 8) {
                                Text(currency.flag)
                                    .font(.title3)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(currency.code)
                                        .font(.subheadline.weight(.bold))
                                    Text(currency.symbol)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(isSelected(currency.code) ? .white.opacity(0.86) : DesignPalette.mutedInk)
                                }
                            }

                            Text(currency.name)
                                .font(.caption)
                                .foregroundStyle(isSelected(currency.code) ? .white.opacity(0.92) : DesignPalette.mutedInk)
                                .lineLimit(2)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                    }
                    .buttonStyle(CurrencyChipButtonStyle(isSelected: selectedCurrencyCode == currency.code))
                }
            }
        }
    }

    private func isSelected(_ code: String) -> Bool {
        selectedCurrencyCode == code
    }
}

private struct CurrencyChipButtonStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isSelected ? Color.white : DesignPalette.ink)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(isSelected ? DesignPalette.accentStrong : DesignPalette.elevatedSurfaceStrong)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(isSelected ? DesignPalette.accentStrong : DesignPalette.stroke.opacity(0.9), lineWidth: 1)
            )
            .shadow(color: isSelected ? DesignPalette.accentStrong.opacity(0.16) : DesignPalette.shadow, radius: isSelected ? 10 : 6, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.18), value: configuration.isPressed)
    }
}
