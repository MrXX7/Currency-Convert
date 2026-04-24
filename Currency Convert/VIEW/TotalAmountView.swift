//
//  TotalAmountView.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import SwiftUI

struct TotalAmountView: View {
    let formattedAmount: String
    let baseCurrency: CurrencyDefinition
    let targetCurrency: CurrencyDefinition
    let amountValue: Double?
    let appliedRate: Double?

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Result")
                .font(.headline)
                .foregroundStyle(DesignPalette.mutedInk)

            Text(formattedAmount)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(DesignPalette.accentStrong)
                .lineLimit(1)
                .minimumScaleFactor(0.75)

            HStack(spacing: 12) {
                summaryPill(title: "From", value: "\(baseCurrency.flag) \(baseCurrency.code)")
                summaryPill(title: "To", value: "\(targetCurrency.flag) \(targetCurrency.code)")
                summaryPill(title: "Rate", value: appliedRateText)
            }

            if let amountValue {
                Text("\(AmountConverter.formattedAmount(amountValue, currencyCode: baseCurrency.code)) converts instantly using the active rate.")
                    .font(.subheadline)
                    .foregroundStyle(DesignPalette.mutedInk)
            } else {
                Text("Enter an amount to see the live conversion.")
                    .font(.subheadline)
                    .foregroundStyle(DesignPalette.mutedInk)
            }
        }
    }

    private var appliedRateText: String {
        guard let appliedRate else {
            return "--"
        }

        return String(format: "%.4f", appliedRate)
    }

    private func summaryPill(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.caption2.weight(.semibold))
                .foregroundStyle(DesignPalette.mutedInk)
            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(DesignPalette.ink)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(DesignPalette.elevatedSurfaceStrong, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(DesignPalette.stroke.opacity(0.9), lineWidth: 1)
        )
    }
}
