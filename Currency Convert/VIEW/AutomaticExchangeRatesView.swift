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
   
   private var leftRates: [String] {
       Array(automaticExchangeRates.prefix(4))
   }
   
   private var rightRates: [String] {
       Array(automaticExchangeRates.suffix(4))
   }

   var body: some View {
       VStack {
           Text("\(selectedCurrency) Exchange Rates")
               .font(.headline)
               .foregroundColor(colorScheme == .dark ? .white : .black)
               .padding(.bottom, 10)
           
           HStack {
               VStack(alignment: .leading) {
                   ForEach(leftRates, id: \.self) { rate in
                       Text(rate)
                           .font(.subheadline)
                           .foregroundColor(colorScheme == .dark ? .gray : .black)
                   }
               }
               
               Spacer()
               
               VStack(alignment: .leading) {
                   ForEach(rightRates, id: \.self) { rate in
                       Text(rate)
                           .font(.subheadline)
                           .foregroundColor(colorScheme == .dark ? .gray : .black)
                   }
               }
           }
           .padding(.horizontal, 10)
       }
       .onTapGesture {
           UIApplication.shared.windows.first?.endEditing(true)
       }
   }
}








