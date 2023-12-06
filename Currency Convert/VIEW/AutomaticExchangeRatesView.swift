//
//  AutomaticExchangeRatesView.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import SwiftUI

struct AutomaticExchangeRatesView: View {
    var automaticExchangeRates: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            ForEach(automaticExchangeRates, id: \.self) { rate in
                if rate.lowercased() != "euro" {
                    Text(rate)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.bottom, 2)
                }
            }
        }
    }
}


