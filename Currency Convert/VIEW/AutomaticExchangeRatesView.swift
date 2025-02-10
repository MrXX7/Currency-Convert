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
       VStack {
           Text("\(selectedCurrency) Exchange Rates")
               .font(.headline)
               .foregroundColor(colorScheme == .dark ? .white : .black)
               .padding(.bottom, 10)
           
           LazyVGrid(columns: [
               GridItem(.flexible(), spacing: 10),
               GridItem(.flexible(), spacing: 10)
           ], spacing: 8) {
               ForEach(automaticExchangeRates, id: \.self) { rate in
                   Text(rate)
                       .font(.subheadline)
                       .foregroundColor(colorScheme == .dark ? .gray : .black)
                       .frame(maxWidth: .infinity, alignment: .leading)
                       .padding(.horizontal, 5)
               }
           }
           .padding(.horizontal, 10)
       }
       .onTapGesture {
           UIApplication.shared.windows.first?.endEditing(true)
       }
   }
}








