//
//  CurrencyFlagDetailView.swift
//  Currency Convert
//
//  Created by Oncu Can on 26.01.2025.
//

import SwiftUI

struct CurrencyFlagDetailView: View {
    var currency: String
    var flagImageName: String

    var body: some View {
        VStack {
            Text(currency)
                .font(.title)
                .padding(.top)

            // Display the flag image based on the image name
            Image(flagImageName)
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                .padding()

            Spacer()
        }
        .navigationBarTitle(Text(currency), displayMode: .inline)
    }
}


