//
//  AutomaticExchangeRatesView.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import SwiftUI

struct AutomaticExchangeRatesView: View {
    @Environment(\.colorScheme) var colorScheme
    var automaticExchangeRates: [String]
    var selectedCurrency: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(selectedCurrency) Exchange Rates")
                    .font(.title3)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .padding(.bottom, 10)
                
                ForEach(automaticExchangeRates, id: \.self) { rate in
                    Text(rate)
                        .font(.body)
                        .foregroundColor(colorScheme == .dark ? .gray : .black)
                        .padding(.bottom, 2)
                }
                
                Spacer()
            }
            .padding(.leading, 10)
                
            Spacer()
        }
        .onTapGesture {
            UIApplication.shared.windows.first?.endEditing(true)
        }
    }
}








