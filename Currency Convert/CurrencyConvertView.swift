//
//  ContentView.swift
//  Currency Convert
//
//  Created by Oncu Can on 29.11.2023.
//

import SwiftUI
import UIKit

private enum ConverterWorkspace: String, CaseIterable, Identifiable {
    case convert
    case market

    var id: String { rawValue }

    var title: String {
        switch self {
        case .convert:
            return "Convert"
        case .market:
            return "Rates"
        }
    }
}

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
    @Published var rateSource: ExchangeRateSource = .live

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
            rateSource = snapshot.source
            errorMessage = snapshot.source == .cache ? "Showing cached exchange rates." : nil

            if targetCurrencyCode == baseCurrencyCode {
                targetCurrencyCode = firstAvailableTarget(for: baseCurrencyCode)
            }
        } catch {
            errorMessage = error.localizedDescription
            rateSource = .live
        }

        isLoading = false
    }

    func normalizeSelections() {
        if targetCurrencyCode == baseCurrencyCode {
            targetCurrencyCode = firstAvailableTarget(for: baseCurrencyCode)
        }
    }

    func applyPreferences(baseCurrencyCode: String, targetCurrencyCode: String, showsAllConversions: Bool, clearInputs: Bool) {
        self.baseCurrencyCode = baseCurrencyCode
        self.targetCurrencyCode = targetCurrencyCode == baseCurrencyCode ? firstAvailableTarget(for: baseCurrencyCode) : targetCurrencyCode
        self.showAllConversions = showsAllConversions

        if clearInputs {
            amountInput = ""
            customExchangeRate = ""
        }
    }

    func swapCurrencies() {
        let previousBase = baseCurrencyCode
        baseCurrencyCode = targetCurrencyCode
        targetCurrencyCode = previousBase
        customExchangeRate = ""
    }

    func reset(baseCurrencyCode: String, targetCurrencyCode: String, showsAllConversions: Bool) {
        amountInput = ""
        customExchangeRate = ""
        self.baseCurrencyCode = baseCurrencyCode
        self.targetCurrencyCode = targetCurrencyCode == baseCurrencyCode ? firstAvailableTarget(for: baseCurrencyCode) : targetCurrencyCode
        self.showAllConversions = showsAllConversions
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
    @State private var showSettings = false
    @State private var hasLoadedStoredDefaults = false
    @State private var showAdvancedControls = false
    @State private var selectedWorkspace: ConverterWorkspace = .convert
    @AppStorage("defaultBaseCurrency") private var defaultBaseCurrency = CurrencyCatalog.supported[0].code
    @AppStorage("defaultTargetCurrency") private var defaultTargetCurrency = CurrencyCatalog.supported[1].code
    @AppStorage("showAllConversionsByDefault") private var showAllConversionsByDefault = false

    var body: some View {
        NavigationStack {
            ZStack {
                DesignPalette.heroGradient
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        headerSection
                        workspacePicker

                        if selectedWorkspace == .convert {
                            converterSection
                        } else {
                            summarySection
                            marketSection
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 124)
                }
                .scrollDismissesKeyboard(.interactively)
                .refreshable {
                    await viewModel.fetchRates()
                }
            }
            .navigationBarHidden(true)
        }
        .task {
            applyStoredDefaultsIfNeeded()
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
        .sheet(isPresented: $showSettings) {
            ConverterSettingsView(
                isDarkMode: $isDarkMode,
                defaultBaseCurrency: $defaultBaseCurrency,
                defaultTargetCurrency: $defaultTargetCurrency,
                showAllConversionsByDefault: $showAllConversionsByDefault,
                onApplyNow: {
                    applyStoredDefaults(clearInputs: false)
                    Task {
                        await viewModel.fetchRates()
                    }
                }
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .safeAreaInset(edge: .bottom) {
            compactResultBar
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Currency Convert")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundStyle(DesignPalette.ink)

                    Text("Clean, fast conversion with live exchange data and a clearer layout.")
                        .font(.subheadline)
                        .foregroundStyle(DesignPalette.ink.opacity(0.78))
                }

                Spacer(minLength: 12)

                HStack(spacing: 10) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(DesignPalette.ink)
                            .padding(12)
                            .background(Color.white.opacity(0.84), in: Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Open settings")
                    .accessibilityHint("Adjust defaults and appearance")

                    DarkModeToggleButton(isDarkMode: $isDarkMode)
                }
            }

            headerMetaRow
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.white.opacity(0.78))
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(DesignPalette.stroke.opacity(0.95), lineWidth: 1)
                )
        )
        .shadow(color: DesignPalette.shadow, radius: 14, x: 0, y: 8)
    }

    private var headerMetaRow: some View {
        HStack(spacing: 8) {
            headerChip("\(viewModel.baseCurrency.flag) \(viewModel.baseCurrency.code)")
            Image(systemName: "arrow.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(DesignPalette.mutedInk)
            headerChip("\(viewModel.targetCurrency.flag) \(viewModel.targetCurrency.code)")
            Spacer(minLength: 8)
            headerChip(compactSourceLabel)
        }
    }

    private var converterSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Convert")
                    .font(.system(.title3, design: .rounded, weight: .semibold))
                    .foregroundStyle(DesignPalette.ink)

                Text("Pick a pair, enter an amount, and track the result from the fixed bar below.")
                    .font(.subheadline)
                    .foregroundStyle(DesignPalette.mutedInk)
            }

            ExchangeRatePickerView(
                title: "From",
                subtitle: "Base currency",
                currencies: CurrencyCatalog.supported,
                selectedCurrencyCode: $viewModel.baseCurrencyCode
            )

            QuickAmountPickerView(quickAmounts: viewModel.quickAmounts, amountInput: $viewModel.amountInput)

            AmountInputView(
                amountInput: $viewModel.amountInput,
                currency: viewModel.baseCurrency,
                isFocused: $isKeyboardFocused
            )

            Button {
                isKeyboardFocused = false
                viewModel.swapCurrencies()
            } label: {
                Label("Swap Base and Target", systemImage: "arrow.up.arrow.down.circle.fill")
            }
            .buttonStyle(SecondaryCapsuleButtonStyle())
            .accessibilityHint("Switches the base and target currencies")

            CurrencyPickerView(
                title: "To",
                subtitle: "Target currency",
                currencies: CurrencyCatalog.supported.filter { $0.code != viewModel.baseCurrencyCode },
                selectedCurrencyCode: $viewModel.targetCurrencyCode
            )

            DisclosureGroup(isExpanded: $showAdvancedControls) {
                VStack(spacing: 14) {
                    ExchangeRateInputView(
                        customExchangeRate: $viewModel.customExchangeRate,
                        targetCurrency: viewModel.targetCurrency.code
                    )

                    HStack(spacing: 10) {
                        ResetButton {
                            isKeyboardFocused = false
                            viewModel.reset(
                                baseCurrencyCode: defaultBaseCurrency,
                                targetCurrencyCode: defaultTargetCurrency,
                                showsAllConversions: showAllConversionsByDefault
                            )
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
                .padding(.top, 12)
            } label: {
                HStack {
                    Label("Advanced controls", systemImage: "slider.horizontal.3")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(DesignPalette.ink)
                    Spacer()
                    Text(showAdvancedControls ? "Hide" : "Show")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(DesignPalette.mutedInk)
                }
            }
            .tint(DesignPalette.accentStrong)
        }
        .cardStyle()
    }

    private var marketSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Rates Explorer")
                        .font(.system(.title3, design: .rounded, weight: .semibold))
                        .foregroundStyle(DesignPalette.ink)

                    Text("Switch between the live rate board and all destination conversions.")
                        .font(.subheadline)
                        .foregroundStyle(DesignPalette.mutedInk)
                }

                Spacer(minLength: 12)

                AllConversionsButtonView(
                    showAllConversions: $viewModel.showAllConversions,
                    amountInput: $viewModel.amountInput
                )
                .frame(maxWidth: 170)
            }

            if viewModel.amountInput.isEmpty && viewModel.showAllConversions {
                Label("Enter an amount in Convert mode to unlock all conversions.", systemImage: "info.circle")
                    .font(.subheadline)
                    .foregroundStyle(DesignPalette.mutedInk)
            }

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
                appliedRate: viewModel.activeRate,
                rateSource: viewModel.rateSource,
                isManualRate: !viewModel.customExchangeRate.isEmpty
            )

            if let errorMessage = viewModel.errorMessage {
                Label(errorMessage, systemImage: "wifi.exclamationmark")
                    .font(.subheadline)
                    .foregroundStyle(viewModel.rateSource == .cache ? DesignPalette.accentStrong : Color.red.opacity(0.85))
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

    private var workspacePicker: some View {
        Picker("Workspace", selection: $selectedWorkspace) {
            ForEach(ConverterWorkspace.allCases) { workspace in
                Text(workspace.title)
                    .tag(workspace)
            }
        }
        .pickerStyle(.segmented)
        .padding(6)
        .background(Color.white.opacity(0.58), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private var rateBadgeText: String {
        guard let activeRate = viewModel.activeRate else {
            return "--"
        }

        return String(format: "%.4f", activeRate)
    }

    private func headerChip(_ text: String) -> some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundStyle(DesignPalette.ink)
            .lineLimit(1)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(DesignPalette.accentSoft.opacity(0.85), in: Capsule())
            .overlay(
                Capsule()
                    .stroke(DesignPalette.stroke.opacity(0.75), lineWidth: 1)
            )
    }

    private func lastUpdatedText(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return "Rates updated \(formatter.localizedString(for: date, relativeTo: .now))"
    }

    private var compactResultBar: some View {
        HStack(alignment: .center, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.amountValue == nil ? "Live Result" : "Current Conversion")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(DesignPalette.mutedInk)

                Text(viewModel.formattedConvertedAmount)
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(DesignPalette.accentStrong)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text(compactResultSubtitle)
                    .font(.caption)
                    .foregroundStyle(DesignPalette.mutedInk)
            }

            Spacer(minLength: 12)

            if viewModel.isLoading {
                ProgressView()
                    .tint(DesignPalette.accentStrong)
            } else {
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Rate")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(DesignPalette.mutedInk)

                    Text(rateBadgeText)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(DesignPalette.ink)

                    Text(compactSourceLabel)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(DesignPalette.mutedInk)
                }
            }

            Button {
                UIPasteboard.general.string = viewModel.formattedConvertedAmount
            } label: {
                Image(systemName: "doc.on.doc")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(DesignPalette.ink)
                    .padding(10)
                    .background(DesignPalette.accentSoft.opacity(0.9), in: Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Copy conversion result")
            .accessibilityHint("Copies the current converted amount")
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.94))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(DesignPalette.stroke.opacity(0.95), lineWidth: 1)
                )
        )
        .shadow(color: DesignPalette.shadow, radius: 16, x: 0, y: 8)
        .accessibilityElement(children: .combine)
    }

    private var compactResultSubtitle: String {
        let pair = "\(viewModel.baseCurrency.code) -> \(viewModel.targetCurrency.code)"
        if !viewModel.customExchangeRate.isEmpty {
            return "\(pair) · Manual rate"
        }

        return viewModel.rateSource == .cache ? "\(pair) · Cached" : "\(pair) · Live"
    }

    private var compactSourceLabel: String {
        if !viewModel.customExchangeRate.isEmpty {
            return "Manual"
        }

        return viewModel.rateSource == .cache ? "Cached" : "Live"
    }

    private func applyStoredDefaultsIfNeeded() {
        guard !hasLoadedStoredDefaults else {
            return
        }

        hasLoadedStoredDefaults = true
        applyStoredDefaults(clearInputs: false)
    }

    private func applyStoredDefaults(clearInputs: Bool) {
        viewModel.applyPreferences(
            baseCurrencyCode: defaultBaseCurrency,
            targetCurrencyCode: defaultTargetCurrency,
            showsAllConversions: showAllConversionsByDefault,
            clearInputs: clearInputs
        )
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
            .shadow(color: DesignPalette.shadow, radius: 18, x: 0, y: 10)
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

private struct ConverterSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isDarkMode: Bool
    @Binding var defaultBaseCurrency: String
    @Binding var defaultTargetCurrency: String
    @Binding var showAllConversionsByDefault: Bool
    let onApplyNow: () -> Void

    private var availableTargetCurrencies: [CurrencyDefinition] {
        CurrencyCatalog.supported.filter { $0.code != defaultBaseCurrency }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }

                Section("Default Pair") {
                    Picker("Base Currency", selection: $defaultBaseCurrency) {
                        ForEach(CurrencyCatalog.supported) { currency in
                            Text("\(currency.flag) \(currency.code) · \(currency.name)")
                                .tag(currency.code)
                        }
                    }

                    Picker("Target Currency", selection: $defaultTargetCurrency) {
                        ForEach(availableTargetCurrencies) { currency in
                            Text("\(currency.flag) \(currency.code) · \(currency.name)")
                                .tag(currency.code)
                        }
                    }
                }

                Section("Behavior") {
                    Toggle("Open with all conversions", isOn: $showAllConversionsByDefault)
                }

                Section {
                    Button("Apply Defaults to Current Screen") {
                        onApplyNow()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                } footer: {
                    Text("These preferences also apply to future resets and new launches.")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onChange(of: defaultBaseCurrency) { _, newValue in
                if defaultTargetCurrency == newValue {
                    defaultTargetCurrency = CurrencyCatalog.supported.first(where: { $0.code != newValue })?.code ?? newValue
                }
            }
        }
    }
}
