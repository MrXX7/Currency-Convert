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

    @State private var selectedIndex = 0
    @State private var showFullScreenImage = false // Tam ekran görüntüleme

    var body: some View {
        VStack {
            TabView(selection: $selectedIndex) {
                ForEach(0..<flagImageNames.count, id: \.self) { index in
                    Image(flagImageNames[index])
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width)
                        .clipped()
                        .tag(index)
                        .rotation3DEffect(
                            .degrees(Double(selectedIndex - index) * 20),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        .opacity(selectedIndex == index ? 1 : 0.7)
                        .animation(.easeInOut(duration: 0.5), value: selectedIndex)
                        .onTapGesture {
                            showFullScreenImage = true // Tam ekran görseli aç
                        }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 300)

            Spacer()
        }
        .sheet(isPresented: $showFullScreenImage) {
            ZoomableImageView(imageName: flagImageNames[selectedIndex])
        }
        .navigationBarTitle(Text(currency), displayMode: .inline)
    }
}

struct ZoomableImageView: View {
    let imageName: String
    @State private var scale: CGFloat = 1.0

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .scaleEffect(scale)
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        scale = value.magnitude
                    }
                    .onEnded { _ in
                        if scale < 1.0 {
                            scale = 1.0 // Minimum zoom
                        }
                    }
            )
            .animation(.easeInOut, value: scale)
    }
}





