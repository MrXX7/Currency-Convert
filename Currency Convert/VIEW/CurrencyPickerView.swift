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
    @State private var searchText = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundStyle(DesignPalette.ink)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(DesignPalette.mutedInk)

            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(DesignPalette.mutedInk)

                TextField("Search currency", text: $searchText)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
                    .font(.subheadline)
                    .foregroundStyle(DesignPalette.ink)

                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.subheadline.weight(.semibold))
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(DesignPalette.mutedInk)
                    .accessibilityLabel("Clear currency search")
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(DesignPalette.surface, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(DesignPalette.stroke.opacity(0.7), lineWidth: 1)
            )

            if filteredCurrencies.isEmpty {
                Label("No matching currencies", systemImage: "magnifyingglass")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(DesignPalette.mutedInk)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                    .background(DesignPalette.elevatedSurface, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(DesignPalette.stroke.opacity(0.7), lineWidth: 1)
                    )
                    .accessibilityHint("Try searching by currency code, name, or region")
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 14)], spacing: 14) {
                    ForEach(filteredCurrencies) { currency in
                        Button {
                            selectedCurrencyCode = currency.code
                        } label: {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(alignment: .center, spacing: 10) {
                                    Text(currency.flag)
                                        .font(.title3)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(currency.code)
                                            .font(.subheadline.weight(.bold))
                                        Text(currency.symbol)
                                            .font(.caption.weight(.semibold))
                                            .foregroundStyle(isSelected(currency.code) ? .white.opacity(0.88) : DesignPalette.mutedInk)
                                    }

                                    Spacer(minLength: 8)

                                    if isSelected(currency.code) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.subheadline.weight(.semibold))
                                            .foregroundStyle(.white.opacity(0.92))
                                    }
                                }

                                Text(currency.name)
                                    .font(.caption)
                                    .foregroundStyle(isSelected(currency.code) ? .white.opacity(0.92) : DesignPalette.mutedInk)
                                    .lineLimit(2)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(14)
                        }
                        .buttonStyle(CurrencyChipButtonStyle(isSelected: selectedCurrencyCode == currency.code))
                        .accessibilityLabel("\(currency.name), \(currency.code)")
                        .accessibilityHint(isSelected(currency.code) ? "Selected currency" : "Selects \(currency.name)")
                    }
                }
            }
        }
    }

    private var filteredCurrencies: [CurrencyDefinition] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !query.isEmpty else {
            return currencies
        }

        return currencies.filter { currency in
            currency.code.localizedCaseInsensitiveContains(query)
                || currency.name.localizedCaseInsensitiveContains(query)
                || currency.region.localizedCaseInsensitiveContains(query)
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
                    .fill(isSelected ? DesignPalette.accentStrong : DesignPalette.surface)
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
