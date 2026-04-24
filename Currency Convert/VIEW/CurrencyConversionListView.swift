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
                .foregroundStyle(DesignPalette.ink)

            if let amountValue {
                Text("\(AmountConverter.formattedAmount(amountValue, currencyCode: baseCurrency.code)) across every supported destination.")
                    .font(.subheadline)
                    .foregroundStyle(DesignPalette.mutedInk)
            } else {
                Text("Enter an amount to populate all destination currencies.")
                    .font(.subheadline)
                    .foregroundStyle(DesignPalette.mutedInk)
            }

            ForEach(conversions) { conversion in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(conversion.currency.flag) \(conversion.currency.code)")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(DesignPalette.ink)
                        Text(conversion.currency.name)
                            .font(.caption)
                            .foregroundStyle(DesignPalette.mutedInk)
                    }

                    Spacer()

                    Text(AmountConverter.formattedAmount(conversion.amount, currencyCode: conversion.currency.code))
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(DesignPalette.accentStrong)
                }
                .padding(14)
                .background(DesignPalette.elevatedSurfaceStrong, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(DesignPalette.stroke.opacity(0.9), lineWidth: 1)
                )
                .shadow(color: DesignPalette.shadow, radius: 8, x: 0, y: 4)
            }
        }
    }
}
