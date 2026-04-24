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
                .foregroundStyle(.secondary)

            Text(formattedAmount)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
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
                    .foregroundStyle(.secondary)
            } else {
                Text("Enter an amount to see the live conversion.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
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
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline.weight(.semibold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.black.opacity(0.04), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
