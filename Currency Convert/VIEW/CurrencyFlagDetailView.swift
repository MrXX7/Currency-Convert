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

    var body: some View {
        VStack {
            Text(currency)
                .font(.title)
                .padding()

            // Use TabView with page style for horizontal swiping between images
            TabView(selection: $selectedIndex) {
                ForEach(0..<flagImageNames.count, id: \.self) { index in
                    Image(flagImageNames[index])
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width) // Ensure image fills the screen width
                        .clipped()
                        .tag(index) // Assign a tag to each page for proper navigation
                        .rotation3DEffect(
                            .degrees(Double(selectedIndex - index) * 20), // Rotate images based on selected index
                            axis: (x: 0, y: 1, z: 0) // Apply the effect on the Y-axis (horizontal)
                        )
                        .opacity(selectedIndex == index ? 1 : 0.7) // Fading effect for non-selected images
                        .animation(.easeInOut(duration: 0.5), value: selectedIndex) // Smooth transition effect
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide default page indicator
            .frame(height: 250) // Set the desired height for images

            Spacer()
        }
        .navigationBarTitle(Text(currency), displayMode: .inline)
    }
}


#Preview {
    CurrencyFlagDetailView(currency: "CAD", flagImageNames: ["CADFlag", "cad1", "cad2", "cad3"])
}



