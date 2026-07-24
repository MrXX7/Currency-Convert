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
    let rateSource: ExchangeRateSource
    let isManualRate: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            resultHeader
            mainAmountDisplay
            conversionSummaryPills
            sourceIndicator
            footerNote
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: formattedAmount)
    }
    
    // MARK: - Subviews
    
    private var resultHeader: some View {
        HStack {
            Text("Conversion Result")
                .font(.system(.subheadline, design: .rounded, weight: .bold))
                .foregroundStyle(DesignPalette.mutedInk)
            Spacer()
            if amountValue != nil {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(DesignPalette.accentStrong)
                    .font(.subheadline)
            }
        }
    }
    
    private var mainAmountDisplay: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(formattedAmount)
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundStyle(DesignPalette.accentStrong)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .contentTransition(.numericText())
            
            if let amount = amountValue {
                Text("\(AmountConverter.formattedAmount(amount, currencyCode: baseCurrency.code)) equals")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(DesignPalette.mutedInk)
            }
        }
    }
    
    private var conversionSummaryPills: some View {
        HStack(spacing: 10) {
            summaryPill(title: "From", value: "\(baseCurrency.flag) \(baseCurrency.code)")
            summaryPill(title: "To", value: "\(targetCurrency.flag) \(targetCurrency.code)")
            summaryPill(title: "Rate", value: appliedRateText)
        }
    }
    
    private var sourceIndicator: some View {
        HStack(spacing: 8) {
            Image(systemName: sourceIcon)
                .font(.caption.weight(.bold))
            
            Text(sourceText)
                .font(.system(.caption, design: .rounded, weight: .bold))
        }
        .foregroundStyle(isManualRate ? DesignPalette.accentStrong : DesignPalette.mutedInk)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(isManualRate ? DesignPalette.accentStrong.opacity(0.1) : DesignPalette.accentSoft.opacity(0.6))
        )
        .overlay(
            Capsule()
                .stroke(isManualRate ? DesignPalette.accentStrong.opacity(0.2) : Color.clear, lineWidth: 1)
        )
    }
    
    private var footerNote: some View {
        Group {
            if amountValue != nil {
                Text("Calculated instantly using the \(isManualRate ? "manual override" : "current market") rate.")
            } else {
                Text("Enter an amount to see the live conversion result.")
            }
        }
        .font(.caption)
        .foregroundStyle(DesignPalette.mutedInk.opacity(0.8))
    }
    
    // MARK: - Helpers
    
    private var appliedRateText: String {
        guard let appliedRate else { return "--" }
        return String(format: "%.4f", appliedRate)
    }

    private var sourceText: String {
        if isManualRate { return "Manual Rate Override" }
        return rateSource == .cache ? "Cached Exchange Rates" : "Live Market Rates"
    }
    
    private var sourceIcon: String {
        if isManualRate { return "slider.horizontal.3" }
        return rateSource == .cache ? "internaldrive.fill" : "bolt.horizontal.circle.fill"
    }

    private func summaryPill(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundStyle(DesignPalette.mutedInk)
            
            Text(value)
                .font(.system(.subheadline, design: .rounded, weight: .bold))
                .foregroundStyle(DesignPalette.ink)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(DesignPalette.surface, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(DesignPalette.stroke.opacity(0.7), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 2)
    }
}
