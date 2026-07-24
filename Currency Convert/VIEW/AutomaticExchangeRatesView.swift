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

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            headerSection
            
            if automaticExchangeRates.isEmpty {
                emptyStateView
            } else {
                rateGrid
            }
        }
    }
    
    // MARK: - Subviews
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("\(selectedCurrency.code) Rate Board")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(DesignPalette.ink)
                
                Spacer()
                
                Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                    .font(.title3)
                    .foregroundStyle(DesignPalette.accentStrong)
            }

            Text("Live indicative rates from your base currency.")
                .font(.subheadline)
                .foregroundStyle(DesignPalette.mutedInk)
        }
    }
    
    private var rateGrid: some View {
        LazyVGrid(columns: columns, spacing: 14) {
            ForEach(automaticExchangeRates) { rate in
                RateCard(rate: rate)
            }
        }
    }
    
    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("No rates available", systemImage: "chart.bar.xaxis")
        } description: {
            Text("Try refreshing or check your network connection.")
        }
        .padding(.vertical, 40)
        .background(DesignPalette.surface.opacity(0.5), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

// MARK: - Helper Views

private struct RateCard: View {
    let rate: CurrencyRate
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Text(rate.currency.flag)
                    .font(.title3)
                Text(rate.currency.code)
                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                    .foregroundStyle(DesignPalette.ink)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(String(format: "%.4f", rate.rate))
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(DesignPalette.accentStrong)
                
                Text(rate.currency.name)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(DesignPalette.mutedInk)
                    .lineLimit(1)
            }

            insightBadge(for: rate.rate)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(DesignPalette.surface, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(DesignPalette.stroke.opacity(0.8), lineWidth: 1)
        )
        .shadow(color: DesignPalette.shadow.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    private func insightBadge(for rateValue: Double) -> some View {
        let insight = getInsight(for: rateValue)
        return Text(insight.text)
            .font(.system(size: 10, weight: .bold, design: .rounded))
            .foregroundStyle(insight.color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(insight.color.opacity(0.1), in: Capsule())
    }
    
    private func getInsight(for rate: Double) -> (text: String, color: Color) {
        if rate < 0.95 {
            return ("Below Parity", .red)
        } else if rate <= 1.05 {
            return ("Near Parity", DesignPalette.accentStrong)
        } else {
            return ("Above Parity", .green)
        }
    }
}
