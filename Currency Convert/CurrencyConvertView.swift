//
//  ContentView.swift
//  Currency Convert
//
//  Created by Oncu Can on 29.11.2023.
//

import SwiftUI

@MainActor
final class CurrencyConverterViewModel: ObservableObject {
    @Published var amountInput = ""
    @Published var customExchangeRate = ""
    @Published var baseCurrencyCode = CurrencyCatalog.supported[0].code
    @Published var targetCurrencyCode = CurrencyCatalog.supported[1].code
    @Published var exchangeRates: [String: Double] = [:]
    @Published var isLoading = false
    @Published var showAllConversions = false
    @Published var errorMessage: String?
    @Published var lastUpdated: Date?

    let quickAmounts = ["5", "10", "25", "50", "100", "250", "500", "1000"]

    var baseCurrency: CurrencyDefinition {
        CurrencyCatalog.currency(code: baseCurrencyCode)
    }

    var targetCurrency: CurrencyDefinition {
        CurrencyCatalog.currency(code: targetCurrencyCode)
    }

    var convertedAmount: Double {
        AmountConverter.convertedAmount(
            amountInput: amountInput,
            customRateInput: customExchangeRate,
            targetCurrencyCode: targetCurrencyCode,
            rates: exchangeRates
        )
    }

    var formattedConvertedAmount: String {
        AmountConverter.formattedAmount(convertedAmount, currencyCode: targetCurrencyCode)
    }

    var activeRate: Double? {
        AmountConverter.decimalValue(from: customExchangeRate) ?? exchangeRates[targetCurrencyCode]
    }

    var automaticExchangeRates: [CurrencyRate] {
        AutomaticExchangeRatesGenerator.generateRates(
            baseCurrencyCode: baseCurrencyCode,
            exchangeRates: exchangeRates
        )
    }

    var allConversions: [ConversionResult] {
        guard let amount = AmountConverter.decimalValue(from: amountInput) else {
            return []
        }

        return automaticExchangeRates.map { rate in
            ConversionResult(currency: rate.currency, amount: amount * rate.rate)
        }
    }

    var amountValue: Double? {
        AmountConverter.decimalValue(from: amountInput)
    }

    func fetchRates() async {
        isLoading = true
        errorMessage = nil

        do {
            let snapshot = try await ExchangeRateFetcher.fetchRates(baseCurrencyCode: baseCurrencyCode)
            exchangeRates = snapshot.rates
            lastUpdated = snapshot.updateTimestamp

            if targetCurrencyCode == baseCurrencyCode {
                targetCurrencyCode = firstAvailableTarget(for: baseCurrencyCode)
            }
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func normalizeSelections() {
        if targetCurrencyCode == baseCurrencyCode {
            targetCurrencyCode = firstAvailableTarget(for: baseCurrencyCode)
        }
    }

    func reset() {
        amountInput = ""
        customExchangeRate = ""
        baseCurrencyCode = CurrencyCatalog.supported[0].code
        targetCurrencyCode = CurrencyCatalog.supported[1].code
        showAllConversions = false
        errorMessage = nil
    }

    private func firstAvailableTarget(for code: String) -> String {
        CurrencyCatalog.supported.first(where: { $0.code != code })?.code ?? code
    }
}

struct CurrencyConvertView: View {
    @Binding var isDarkMode: Bool
    @StateObject private var viewModel = CurrencyConverterViewModel()
    @FocusState private var isKeyboardFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                DesignPalette.heroGradient
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        headerSection
                        converterSection
                        summarySection
                        ratesSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 28)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationBarHidden(true)
        }
        .task {
            await viewModel.fetchRates()
        }
        .task(id: viewModel.baseCurrencyCode) {
            viewModel.normalizeSelections()
            await viewModel.fetchRates()
        }
        .onChange(of: viewModel.amountInput) { _, newValue in
            let sanitized = AmountConverter.sanitize(newValue)
            if sanitized != newValue {
                viewModel.amountInput = sanitized
            }
        }
        .onChange(of: viewModel.customExchangeRate) { _, newValue in
            let sanitized = AmountConverter.sanitize(newValue)
            if sanitized != newValue {
                viewModel.customExchangeRate = sanitized
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Currency Convert")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundStyle(.white)

                    Text("Clean, fast conversion with live exchange data and a clearer layout.")
                        .font(.subheadline)
                        .foregroundStyle(DesignPalette.ink.opacity(0.78))
                }

                Spacer(minLength: 12)

                DarkModeToggleButton(isDarkMode: $isDarkMode)
            }

            HStack(spacing: 12) {
                headerStat(
                    title: "Base",
                    value: "\(viewModel.baseCurrency.flag) \(viewModel.baseCurrency.code)"
                )

                headerStat(
                    title: "Target",
                    value: "\(viewModel.targetCurrency.flag) \(viewModel.targetCurrency.code)"
                )

                headerStat(
                    title: "Rate",
                    value: rateBadgeText
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.white.opacity(0.58))
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(DesignPalette.stroke.opacity(0.95), lineWidth: 1)
                )
        )
    }

    private var converterSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Conversion Setup")
                .font(.system(.title3, design: .rounded, weight: .semibold))

            ExchangeRatePickerView(
                title: "You have",
                subtitle: "Select the base currency for fresh live rates.",
                currencies: CurrencyCatalog.supported,
                selectedCurrencyCode: $viewModel.baseCurrencyCode
            )

            QuickAmountPickerView(quickAmounts: viewModel.quickAmounts, amountInput: $viewModel.amountInput)

            AmountInputView(
                amountInput: $viewModel.amountInput,
                currency: viewModel.baseCurrency,
                isFocused: $isKeyboardFocused
            )

            CurrencyPickerView(
                title: "Convert to",
                subtitle: "Choose the output currency for the main result card.",
                currencies: CurrencyCatalog.supported.filter { $0.code != viewModel.baseCurrencyCode },
                selectedCurrencyCode: $viewModel.targetCurrencyCode
            )

            ExchangeRateInputView(
                customExchangeRate: $viewModel.customExchangeRate,
                targetCurrency: viewModel.targetCurrency.code
            )

            HStack(spacing: 10) {
                AllConversionsButtonView(
                    showAllConversions: $viewModel.showAllConversions,
                    amountInput: $viewModel.amountInput
                )

                ResetButton {
                    isKeyboardFocused = false
                    viewModel.reset()
                }

                Button {
                    Task {
                        await viewModel.fetchRates()
                    }
                } label: {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
                .buttonStyle(SecondaryCapsuleButtonStyle())
                .disabled(viewModel.isLoading)
            }
        }
        .cardStyle()
    }

    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            TotalAmountView(
                formattedAmount: viewModel.formattedConvertedAmount,
                baseCurrency: viewModel.baseCurrency,
                targetCurrency: viewModel.targetCurrency,
                amountValue: viewModel.amountValue,
                appliedRate: viewModel.activeRate
            )

            if let errorMessage = viewModel.errorMessage {
                Label(errorMessage, systemImage: "wifi.exclamationmark")
                    .font(.subheadline)
                    .foregroundStyle(Color.red.opacity(0.85))
            } else if viewModel.isLoading {
                HStack(spacing: 10) {
                    ProgressView()
                        .tint(DesignPalette.accentStrong)
                    Text("Updating rates...")
                        .font(.subheadline)
                        .foregroundStyle(DesignPalette.mutedInk)
                }
            } else if let lastUpdated = viewModel.lastUpdated {
                Label(lastUpdatedText(from: lastUpdated), systemImage: "clock")
                    .font(.subheadline)
                    .foregroundStyle(DesignPalette.mutedInk)
            }
        }
        .cardStyle()
    }

    private var ratesSection: some View {
        Group {
            if viewModel.showAllConversions {
                CurrencyConversionListView(
                    conversions: viewModel.allConversions,
                    baseCurrency: viewModel.baseCurrency,
                    amountValue: viewModel.amountValue
                )
            } else {
                AutomaticExchangeRatesView(
                    automaticExchangeRates: viewModel.automaticExchangeRates,
                    selectedCurrency: viewModel.baseCurrency
                )
            }
        }
        .cardStyle()
    }

    private var rateBadgeText: String {
        guard let activeRate = viewModel.activeRate else {
            return "--"
        }

        return String(format: "%.4f", activeRate)
    }

    private func headerStat(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title.uppercased())
                .font(.caption2.weight(.semibold))
                .foregroundStyle(DesignPalette.mutedInk)

            Text(value)
                .font(.headline.weight(.semibold))
                .foregroundStyle(DesignPalette.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(DesignPalette.accentSoft.opacity(0.85), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private func lastUpdatedText(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return "Rates updated \(formatter.localizedString(for: date, relativeTo: .now))"
    }
}

private struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(DesignPalette.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .stroke(DesignPalette.stroke.opacity(0.9), lineWidth: 1)
                    )
            )
            .shadow(color: DesignPalette.accentStrong.opacity(0.10), radius: 18, x: 0, y: 10)
    }
}

private extension View {
    func cardStyle() -> some View {
        modifier(CardModifier())
    }
}

#Preview {
    CurrencyConvertView(isDarkMode: .constant(false))
}
