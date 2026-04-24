//
//  CurrencyImagesView.swift
//  Currency Convert
//
//  Created by Oncu Can on 26.01.2025.
//

import SwiftUI

struct CurrencyImagesView: View {
    @State private var searchText = ""

    private var filteredCurrencies: [CurrencyDefinition] {
        if searchText.isEmpty {
            return CurrencyCatalog.supported
        }

        return CurrencyCatalog.supported.filter {
            $0.code.localizedCaseInsensitiveContains(searchText) ||
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.region.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    heroCard

                    if filteredCurrencies.isEmpty {
                        ContentUnavailableView(
                            "No Matches",
                            systemImage: "magnifyingglass",
                            description: Text("Try searching by code, currency name, or region.")
                        )
                        .frame(maxWidth: .infinity, minHeight: 240)
                    } else {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 14)], spacing: 14) {
                            ForEach(filteredCurrencies) { currency in
                                NavigationLink {
                                    CurrencyFlagDetailView(
                                        currency: currency,
                                        flagImageNames: imageNames(for: currency.code)
                                    )
                                } label: {
                                    currencyCard(for: currency)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(16)
            }
            .background(DesignPalette.surface)
            .navigationTitle("Currency Library")
            .searchable(text: $searchText, prompt: "Search currency or region")
        }
    }

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Banknotes and Flags")
                .font(.system(.title2, design: .rounded, weight: .bold))
                .foregroundStyle(.white)

            Text("A cleaner gallery for exploring supported currencies and their visual references.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.88))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            DesignPalette.libraryGradient,
            in: RoundedRectangle(cornerRadius: 28, style: .continuous)
        )
        .foregroundStyle(.white)
    }

    private func imageNames(for currencyCode: String) -> [String] {
        ([currencyCode + "Flag"] + (1...8).map { "\(currencyCode.lowercased())\($0)" })
            .filter { UIImage(named: $0) != nil }
    }

    private func currencyCard(for currency: CurrencyDefinition) -> some View {
        let background = RoundedRectangle(cornerRadius: 24, style: .continuous)

        return VStack(alignment: .leading, spacing: 12) {
            Text(currency.flag)
                .font(.system(size: 42))

            Text(currency.code)
                .font(.headline.weight(.bold))
                .foregroundStyle(DesignPalette.ink)

            Text(currency.name)
                .font(.subheadline)
                .foregroundStyle(DesignPalette.mutedInk)
                .lineLimit(2)

            Text(currency.region)
                .font(.caption.weight(.semibold))
                .foregroundStyle(DesignPalette.accentStrong)
        }
        .frame(maxWidth: .infinity, minHeight: 150, alignment: .leading)
        .padding(16)
        .background(
            background
                .fill(DesignPalette.elevatedSurfaceStrong)
                .shadow(color: DesignPalette.shadow, radius: 12, x: 0, y: 8)
        )
        .overlay(
            background
                .stroke(DesignPalette.stroke.opacity(0.9), lineWidth: 1)
        )
    }
}

#Preview {
    CurrencyImagesView()
}
