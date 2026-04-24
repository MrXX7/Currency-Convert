//
//  CurrencyFlagDetailView.swift
//  Currency Convert
//
//  Created by Oncu Can on 26.01.2025.
//

import SwiftUI

struct CurrencyFlagDetailView: View {
    let currency: CurrencyDefinition
    let flagImageNames: [String]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(currency.flag)
                        .font(.system(size: 62))

                    Text(currency.code)
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))

                    Text(currency.name)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
                .background(
                    DesignPalette.libraryGradient,
                    in: RoundedRectangle(cornerRadius: 30, style: .continuous)
                )
                .foregroundStyle(.white)

                if flagImageNames.isEmpty {
                    ContentUnavailableView("No Images Yet", systemImage: "photo.on.rectangle", description: Text("Add more assets to enrich this currency page."))
                } else {
                    TabView {
                        ForEach(flagImageNames, id: \.self) { imageName in
                            if let uiImage = UIImage(named: imageName) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity, maxHeight: 290)
                                    .padding(18)
                                    .background(DesignPalette.elevatedSurface, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
                                    .padding(.horizontal, 2)
                            }
                        }
                    }
                    .frame(height: 330)
                    .tabViewStyle(.page(indexDisplayMode: .automatic))
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Overview")
                        .font(.headline)

                    detailRow(title: "Code", value: currency.code)
                    detailRow(title: "Region", value: currency.region)
                    detailRow(title: "Symbol", value: currency.symbol)

                    Text(currency.description)
                        .font(.body)
                        .foregroundStyle(DesignPalette.mutedInk)
                        .padding(.top, 6)
                }
                .padding(20)
                .background(DesignPalette.elevatedSurface, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            }
            .padding(16)
        }
        .background(DesignPalette.surface)
        .navigationTitle(currency.code)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline.weight(.semibold))
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundStyle(DesignPalette.mutedInk)
        }
    }
}
