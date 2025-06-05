//
//  CurrencyFlagDetailView.swift
//  Currency Convert
//
//  Created by Oncu Can on 26.01.2025.
//

import SwiftUI

struct CurrencyFlagDetailView: View {
    var currency: String
    var flagImageNames: [String] // Array of image names for the selected currency
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    
    var body: some View {
        VStack {
            // Navigation Bar with custom title and dismiss button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("\(currency) Flags")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                // Placeholder to balance the layout, or can be another action button
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 30, height: 30)
            }
            .padding()
            
            // Display images horizontally if multiple exist
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) { // Spacing between images
                    ForEach(flagImageNames, id: \.self) { imageName in
                        if let uiImage = UIImage(named: imageName) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250, height: 200) // Fixed size for consistency
                                .cornerRadius(15)
                                .shadow(radius: 5)
                                .accessibilityLabel("Flag image for \(currency) - \(imageName)") // Accessibility
                        } else {
                            // Fallback for missing images
                            Image(systemName: "flag.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250, height: 200)
                                .foregroundColor(.gray)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                                .accessibilityLabel("Placeholder flag image for \(currency)")
                        }
                    }
                }
                .padding(.horizontal) // Padding for the scroll view content
            }
            
            // Additional Information (Example)
            VStack(alignment: .leading, spacing: 10) {
                Text("About \(currency):")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                Text("This section can include more details about the \(currency) currency, its history, or its economic significance.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            .padding()
            
            Spacer()
        }
        .navigationBarHidden(true) // Hide default navigation bar
    }
}







