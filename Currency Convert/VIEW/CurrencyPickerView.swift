//
//  CurrencyPickerView.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import SwiftUI

struct CurrencyPickerView: View {
    var currencies: [String]
    @Binding var selectedCurrencyIndex: Int

    var body: some View {
        Picker("", selection: $selectedCurrencyIndex) {
            ForEach(0..<currencies.count) {
                if self.currencies[$0] != "EUR" {
                    Text(self.currencies[$0])
                }
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

