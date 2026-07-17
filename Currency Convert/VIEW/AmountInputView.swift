//
//  AmountInputView.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import Foundation
import SwiftUI

struct AmountInputView: View {
    @Binding var amountInput: String
    let currency: CurrencyDefinition
    @FocusState.Binding var isFocused: Bool
    @State private var showInputWarning: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Amount")
                .font(.headline)
                .foregroundStyle(DesignPalette.ink)

            if showInputWarning {
                Text("Lütfen geçerli bir miktar girin")
                    .font(.caption)
                    .foregroundColor(.red)
            }

            HStack(alignment: .firstTextBaseline, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(currency.code)
                        .font(.headline.weight(.semibold))
                    Text(currency.name)
                        .font(.caption)
                        .foregroundStyle(DesignPalette.mutedInk)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(DesignPalette.accentSoft, in: RoundedRectangle(cornerRadius: 16, style: .continuous))

                TextField("0.00", text: $amountInput)
                    .keyboardType(.decimalPad)
                    .focused($isFocused)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.trailing)
                    .foregroundStyle(DesignPalette.ink)
                    .onChange(of: amountInput) { newValue in
                        var filtered = ""
                        var decimalSeparatorCount = 0
                        for char in newValue {
                            if char.isNumber {
                                filtered.append(char)
                            } else if char == "." || char == "," {
                                if decimalSeparatorCount == 0 {
                                    filtered.append(char)
                                    decimalSeparatorCount += 1
                                }
                            }
                        }
                        if filtered != newValue {
                            amountInput = filtered
                            showInputWarning = true
                        } else {
                            showInputWarning = false
                        }
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                isFocused = false
                            }
                        }
                    }
            }
            .padding(16)
            .background(DesignPalette.elevatedSurfaceStrong, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(DesignPalette.stroke.opacity(0.9), lineWidth: 1)
            )
            .shadow(color: DesignPalette.shadow, radius: 10, x: 0, y: 4)
        }
    }
}
