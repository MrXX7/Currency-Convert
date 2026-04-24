//
//  ExchangeRatePickerView.swift
//  Currency Convert
//
//  Created by Oncu Can on 23.05.2024.
//

import SwiftUI

struct ExchangeRatePickerView: View {
    let title: String
    let subtitle: String
    let currencies: [CurrencyDefinition]
    @Binding var selectedCurrencyCode: String

    var body: some View {
        CurrencyPickerView(
            title: title,
            subtitle: subtitle,
            currencies: currencies,
            selectedCurrencyCode: $selectedCurrencyCode
        )
    }
}
