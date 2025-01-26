//
//  CurrencyFlagDetailView.swift
//  Currency Convert
//
//  Created by Oncu Can on 26.01.2025.
//

import SwiftUI

struct CurrencyFlagDetailView: View {
    var currency: String
    var flag: String

    var body: some View {
        VStack {
            Text(currency)
                .font(.title)
                .padding(.top)

            Text(flag)
                .font(.system(size: 200)) // Larger size for the flag
                .padding()

            Spacer()
        }
        .navigationBarTitle(Text(currency), displayMode: .inline)
    }
}

