//
//  CurrencyFlagDetailView 2.swift
//  Currency Convert
//
//  Created by Oncu Can on 26.01.2025.
//


import SwiftUI

struct CurrencyFlagDetailView: View {
    var currency: String
    var flagImageName: String
    var additionalImages: [String]

    var body: some View {
        VStack {
            Image(flagImageName)
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                .padding()

            // Tinder-style swipeable images (horizontal scrolling)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(additionalImages, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)
                            .padding()
                    }
                }
            }

            Spacer()
        }
        .navigationBarTitle(Text(currency), displayMode: .inline)
    }
}
