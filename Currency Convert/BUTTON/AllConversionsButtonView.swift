//
//  AllConversionsButtonView.swift
//  Currency Convert
//
//  Created by Oncu Can on 1.10.2024.
//

import SwiftUI
import UIKit

struct AllConversionsButtonView: View {
    @Binding var showAllConversions: Bool
    @Binding var amountInput: String

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                showAllConversions.toggle()
            }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            Label(showAllConversions ? "Hide Grid" : "Show All", systemImage: showAllConversions ? "rectangle.grid.1x2.fill" : "square.grid.2x2.fill")
        }
        .buttonStyle(PrimaryCapsuleButtonStyle(isProminent: showAllConversions))
        .disabled(amountInput.isEmpty)
        .opacity(amountInput.isEmpty ? 0.55 : 1)
    }
}
