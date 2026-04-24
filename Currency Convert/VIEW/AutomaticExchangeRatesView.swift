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

            Text("Live indicative rates from the selected base currency.")
                .font(.subheadline)
                .foregroundStyle(DesignPalette.mutedInk)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(automaticExchangeRates) { rate in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(rate.currency.flag)
                            Text(rate.currency.code)
                                .font(.headline)
                        }

                        Text(String(format: "%.4f", rate.rate))
                            .font(.title3.weight(.bold))

                        Text(rate.currency.name)
                            .font(.caption)
                            .foregroundStyle(DesignPalette.mutedInk)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                    .background(DesignPalette.elevatedSurface, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(DesignPalette.stroke.opacity(0.9), lineWidth: 1)
                    )
                }
            }
        }
    }
}
