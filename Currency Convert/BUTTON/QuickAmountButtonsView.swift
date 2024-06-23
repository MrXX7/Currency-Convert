//
//  QuickAmountButtonsView.swift
//  Currency Convert
//
//  Created by Oncu Can on 12.06.2024.
//

import SwiftUI
import Foundation

struct QuickAmountPickerView: View {
    @Environment(\.colorScheme) var colorScheme
    var quickAmounts: [String]
    @Binding var euroAmount: String

    var body: some View {
        VStack {
            Picker("Select Amount", selection: $euroAmount) {
                ForEach(quickAmounts, id: \.self) { amount in
                    Text(amount).tag(amount)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding(.vertical, 8)
    }
}
