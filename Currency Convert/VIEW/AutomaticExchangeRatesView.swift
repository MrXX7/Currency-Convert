//
//  AutomaticExchangeRatesView.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import SwiftUI

struct AutomaticExchangeRatesView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var customExchangeRate: String = ""
    var automaticExchangeRates: [String]

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Euro Exchange Rates")
                    .font(.title3)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .padding(.bottom, 10)
                
                ForEach(automaticExchangeRates, id: \.self) { rate in
                    if rate.lowercased() != "euro" {
                        Text(rate)
                            .font(.body)
                            .foregroundColor(colorScheme == .dark ? .gray : .black)
                            .padding(.bottom, 2)
                    }
                }
                
                Spacer()
            }
            .padding(.leading, 10) // Sol taraf için artırılmış padding
                
            Spacer() // HStack'in solunu tam sıfır yapmak için Spacer ekleyin
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}







