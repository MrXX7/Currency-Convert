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
            //            .padding()
            ////            .background(colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray4))
            //            .cornerRadius(10)
            //            .shadow(color: colorScheme == .dark ? Color.black.opacity(0.2) : Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
            //        }
        }
        .padding(.vertical, 8)
    }
}
