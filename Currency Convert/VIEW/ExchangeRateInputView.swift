//
//  ExchangeRateInputView.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import SwiftUI

struct ExchangeRateInputView: View {
    @Binding var customExchangeRate: String
    let targetCurrency: String
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerRow
            inputField
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isFocused)
    }
    
    // MARK: - Subviews
    
    private var headerRow: some View {
        HStack {
            Label("Manual Rate", systemImage: "pencil.and.outline")
                .font(.system(.headline, design: .rounded, weight: .bold))
                .foregroundStyle(DesignPalette.ink)
            
            Spacer()
            
            Text("Optional")
                .font(.caption.weight(.semibold))
                .foregroundStyle(DesignPalette.mutedInk)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(DesignPalette.surface, in: Capsule())
                .overlay(Capsule().stroke(DesignPalette.stroke.opacity(0.5), lineWidth: 1))
        }
    }
    
    private var inputField: some View {
        HStack(spacing: 12) {
            Image(systemName: "coloncurrencysign.circle.fill")
                .font(.title3)
                .foregroundStyle(isFocused ? DesignPalette.accentStrong : DesignPalette.mutedInk)
                .scaleEffect(isFocused ? 1.1 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isFocused)

            TextField("Override 1 \(targetCurrency) rate", text: $customExchangeRate)
                .keyboardType(.decimalPad)
                .textFieldStyle(.plain)
                .focused($isFocused)
                .font(.system(.body, design: .rounded, weight: .medium))
                .foregroundStyle(DesignPalette.ink)
                .submitLabel(.done)

            if !customExchangeRate.isEmpty {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        customExchangeRate = ""
                    }
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(DesignPalette.mutedInk)
                }
                .buttonStyle(.plain)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(isFocused ? DesignPalette.surface : DesignPalette.elevatedSurfaceStrong)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(isFocused ? DesignPalette.accentStrong.opacity(0.6) : DesignPalette.stroke.opacity(0.8), lineWidth: 1.5)
        )
        .shadow(color: isFocused ? DesignPalette.accentStrong.opacity(0.12) : DesignPalette.shadow.opacity(0.05), radius: 12, x: 0, y: 6)
        .toolbar {
            if isFocused {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isFocused = false
                    }
                    .font(.headline)
                    .foregroundStyle(DesignPalette.accentStrong)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        DesignPalette.heroGradient.ignoresSafeArea()
        VStack {
            ExchangeRateInputView(customExchangeRate: .constant(""), targetCurrency: "USD")
                .padding()
            ExchangeRateInputView(customExchangeRate: .constant("1.234"), targetCurrency: "EUR")
                .padding()
        }
    }
}
