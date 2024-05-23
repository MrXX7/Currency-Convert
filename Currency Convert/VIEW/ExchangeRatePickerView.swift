//
//  ExchangeRatePickerView.swift
//  Currency Convert
//
//  Created by Oncu Can on 23.05.2024.
//

import SwiftUI

struct ExchangeRatePickerView: View {
    var currencies: [String]
    @Binding var selectedRateCurrencyIndex: Int

    var body: some View {
        Picker("Select Currency", selection: $selectedRateCurrencyIndex) {
            ForEach(0..<currencies.count, id: \.self) {
                Text(self.currencies[$0])
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
}
