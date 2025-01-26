//
//  CurrencyFlagDetailView.swift
//  Currency Convert
//
//  Created by Oncu Can on 26.01.2025.
//

import SwiftUI

struct CurrencyFlagDetailView: View {
    var currency: String
    var flagImageNames: [String]

    var body: some View {
        VStack {
            // Title for the currency
            Text(currency)
                .font(.title)
                .padding()

            // Horizontal ScrollView for images
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(flagImageNames, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                }
                .padding()
            }

            Spacer()
        }
        .navigationBarTitle(Text(currency), displayMode: .inline)
    }
}

#Preview {
    CurrencyFlagDetailView(currency: "CAD", flagImageNames: ["CADFlag", "cad1", "cad2", "cad3"])
}



