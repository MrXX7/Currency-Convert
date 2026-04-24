//
//  QuickAmountButtonsView.swift
//  Currency Convert
//
//  Created by Oncu Can on 12.06.2024.
//

import SwiftUI

struct PrimaryCapsuleButtonStyle: ButtonStyle {
    var isProminent: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(isProminent ? Color.white : Color.primary)
            .padding(.vertical, 11)
            .padding(.horizontal, 14)
            .frame(maxWidth: .infinity)
            .background(
                Capsule()
                    .fill(isProminent ? Color.accentColor : Color.white.opacity(0.7))
            )
            .overlay(
                Capsule()
                    .stroke(Color.black.opacity(0.06), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.18), value: configuration.isPressed)
    }
}

struct SecondaryCapsuleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(Color.primary)
            .padding(.vertical, 11)
            .padding(.horizontal, 14)
            .frame(maxWidth: .infinity)
            .background(Color.black.opacity(0.04), in: Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.black.opacity(0.08), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.18), value: configuration.isPressed)
    }
}

struct QuickAmountPickerView: View {
    let quickAmounts: [String]
    @Binding var amountInput: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Quick Select")
                .font(.headline)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 72), spacing: 10)], spacing: 10) {
                ForEach(quickAmounts, id: \.self) { amount in
                    Button(amount) {
                        amountInput = amount
                    }
                    .buttonStyle(PrimaryCapsuleButtonStyle(isProminent: amountInput == amount))
                }
            }
        }
    }
}
