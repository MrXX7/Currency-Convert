//
//  AutomaticExchangeRatesView.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import SwiftUI

struct AutomaticExchangeRatesView: View {
    let automaticExchangeRates: [CurrencyRate]
    let selectedCurrency: CurrencyDefinition

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(selectedCurrency.code) Rate Board")
                .font(.system(.title3, design: .rounded, weight: .semibold))
                .foregroundStyle(DesignPalette.ink)

            Text("Live indicative rates from the selected base currency.")
                .font(.subheadline)
                .foregroundStyle(DesignPalette.mutedInk)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(automaticExchangeRates) { rate in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(rate.currency.flag)
                            Text(rate.currency.code)
                                .font(.headline.weight(.bold))
                                .foregroundStyle(DesignPalette.ink)
                        }

                        Text(String(format: "%.4f", rate.rate))
                            .font(.title3.weight(.bold))
                            .foregroundStyle(DesignPalette.accentStrong)

                        Text(rate.currency.name)
                            .font(.caption)
                            .foregroundStyle(DesignPalette.mutedInk)

                        Text(insightText(for: rate.rate))
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(DesignPalette.accentStrong)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .background(DesignPalette.accentSoft.opacity(0.8), in: Capsule())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                    .background(DesignPalette.elevatedSurfaceStrong, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(DesignPalette.stroke.opacity(0.9), lineWidth: 1)
                    )
                    .shadow(color: DesignPalette.shadow, radius: 8, x: 0, y: 4)
                }
            }
        }
    }

    private func insightText(for rate: Double) -> String {
        switch rate {
        case 0..<0.9:
            return "Below parity"
        case 0.9...1.1:
            return "Near parity"
        default:
            return "Above parity"
        }
    }
}
