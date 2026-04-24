//
//  CurrencyConversionListView.swift
//  Currency Convert
//
//  Created by Oncu Can on 27.09.2024.
//

import SwiftUI

struct CurrencyConversionListView: View {
    let conversions: [ConversionResult]
    let baseCurrency: CurrencyDefinition
    let amountValue: Double?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("All Conversions")
                .font(.system(.title3, design: .rounded, weight: .semibold))

            if let amountValue {
                Text("\(AmountConverter.formattedAmount(amountValue, currencyCode: baseCurrency.code)) across every supported destination.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                Text("Enter an amount to populate all destination currencies.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            ForEach(conversions) { conversion in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(conversion.currency.flag) \(conversion.currency.code)")
                            .font(.headline)
                        Text(conversion.currency.name)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Text(AmountConverter.formattedAmount(conversion.amount, currencyCode: conversion.currency.code))
                        .font(.headline.weight(.semibold))
                }
                .padding(14)
                .background(Color.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
        }
    }
}
