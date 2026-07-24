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
    
    // Performance optimization: Filter currencies only when searchText or currencies change
    private var filteredCurrencies: [CurrencyDefinition] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return currencies }
        
        return currencies.filter { currency in
            currency.code.localizedCaseInsensitiveContains(query)
                || currency.name.localizedCaseInsensitiveContains(query)
                || currency.region.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            headerSection
            searchBar
            currencyGrid
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: searchText)
    }
    
    // MARK: - Subviews
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(.headline, design: .rounded, weight: .bold))
                .foregroundStyle(DesignPalette.ink)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(DesignPalette.mutedInk)
        }
    }
    
    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(DesignPalette.mutedInk)

            TextField("Search by code, name, or region", text: $searchText)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
                .font(.subheadline)
                .foregroundStyle(DesignPalette.ink)
                .submitLabel(.search)

            if !searchText.isEmpty {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        searchText = ""
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(DesignPalette.mutedInk)
                }
                .buttonStyle(.plain)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(DesignPalette.surface, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(DesignPalette.stroke.opacity(0.8), lineWidth: 1)
        )
    }
    
    private var currencyGrid: some View {
        Group {
            if filteredCurrencies.isEmpty {
                emptyStateView
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)], spacing: 12) {
                    ForEach(filteredCurrencies) { currency in
                        CurrencyChip(
                            currency: currency,
                            isSelected: selectedCurrencyCode == currency.code
                        ) {
                            selectCurrency(currency)
                        }
                    }
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        Label("No matching currencies", systemImage: "magnifyingglass")
            .font(.subheadline.weight(.medium))
            .foregroundStyle(DesignPalette.mutedInk)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            .background(DesignPalette.surface.opacity(0.5), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(DesignPalette.stroke.opacity(0.5), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
            )
    }
    
    // MARK: - Actions
    
    private func selectCurrency(_ currency: CurrencyDefinition) {
        if selectedCurrencyCode != currency.code {
            selectedCurrencyCode = currency.code
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
}

// MARK: - Helper Views

private struct CurrencyChip: View {
    let currency: CurrencyDefinition
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    Text(currency.flag)
                        .font(.title2)
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.white)
                    }
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(currency.code)
                        .font(.system(.subheadline, design: .rounded, weight: .bold))
                    
                    Text(currency.name)
                        .font(.caption2)
                        .lineLimit(1)
                }
                .foregroundStyle(isSelected ? .white : DesignPalette.ink)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(isSelected ? DesignPalette.accentStrong : DesignPalette.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(isSelected ? Color.clear : DesignPalette.stroke.opacity(0.9), lineWidth: 1)
            )
            .shadow(color: isSelected ? DesignPalette.accentStrong.opacity(0.25) : Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// Extension removed to fix compilation error
