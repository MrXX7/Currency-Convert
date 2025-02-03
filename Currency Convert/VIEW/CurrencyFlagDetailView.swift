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
    @State private var showFullScreenImage = false
    
    var body: some View {
        VStack {
            TabView(selection: $selectedIndex) {
                ForEach(0..<flagImageNames.count, id: \.self) { index in
                    GeometryReader { geometry in
                        Image(flagImageNames[index])
                            .resizable()
                            .aspectRatio(contentMode: .fit) // Kırpmadan uygun boyutlandır
                            .frame(width: geometry.size.width * 0.9) // Ekran genişliğinin %90'ını kapla
                            .clipped()
                            .tag(index)
                            .rotation3DEffect(
                                .degrees(Double(selectedIndex - index) * 20),
                                axis: (x: 0, y: 1, z: 0)
                            )
                            .opacity(selectedIndex == index ? 1 : 0.7)
                            .animation(.easeInOut(duration: 0.5), value: selectedIndex)
                            .onTapGesture {
                                showFullScreenImage = true
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // TAM ORTALAMA
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 300)
            
            Spacer()
        }
        .sheet(isPresented: $showFullScreenImage) {
            ZoomableImageView(imageName: flagImageNames[selectedIndex]) {
                showFullScreenImage = false
            }
        }
        .navigationBarTitle(Text(currency), displayMode: .inline)
    }
}


struct ZoomableImageView: View {
    let imageName: String
    let onClose: () -> Void
    @State private var scale: CGFloat = 1.0

    var body: some View {
        VStack {
            Button("Kapat") {
                onClose()
            }
            .padding()

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity) // TAM ORTALAMA
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
}







