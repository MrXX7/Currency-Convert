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
    
    // You might want to get this info from a model or API in a real app
    private var currencyInfo: String {
        switch currency {
        case "EUR": return "The Euro is the official currency of 20 of the 27 member states of the European Union. It is the second largest and second most traded currency in the foreign exchange market after the United States dollar."
        case "USD": return "The United States Dollar is the official currency of the United States and its insular territories. It is the most used currency in international transactions and is considered the world's primary reserve currency."
        case "GBP": return "The Pound Sterling is the official currency of the United Kingdom and several other countries and territories. It is the fourth most traded currency in the foreign exchange market."
        case "TRY": return "The Turkish Lira is the official currency of Turkey and the Turkish Republic of Northern Cyprus. It has experienced significant fluctuations in its value over recent years."
        case "CAD": return "The Canadian Dollar is the currency of Canada. It is the fifth most traded currency in the world, known for its stability and often referred to as a 'loonie'."
        case "CHF": return "The Swiss Franc is the currency and legal tender of Switzerland and Liechtenstein. It is known for its stability and strength, often considered a safe-haven currency."
        case "SAR": return "The Saudi Riyal is the currency of Saudi Arabia. It is pegged to the US Dollar and is central to the Saudi economy, heavily influenced by oil prices."
        case "AUD": return "The Australian Dollar is the currency of Australia, including Christmas Island, Cocos (Keeling) Islands, and Norfolk Island. It is a popular currency among traders due to its strong commodity ties."
        case "CNY": return "The Chinese Yuan Renminbi is the official currency of the People's Republic of China. It is managed by the People's Bank of China and its value is closely watched by global markets."
        default: return "Information about \(currency) is not available."
        }
    }
    
    var body: some View {
        VStack {
            // Custom Navigation Bar with title and dismiss button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("\(currency) Details")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Rectangle() // Placeholder to balance layout
                    .fill(Color.clear)
                    .frame(width: 30, height: 30)
            }
            .padding()
            
            // TabView for page-style scrolling of flag images
            TabView {
                ForEach(flagImageNames, id: \.self) { imageName in
                    VStack {
                        if let uiImage = UIImage(named: imageName) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, maxHeight: 250) // Adjust max height for page view
                                .cornerRadius(15)
                                .shadow(radius: 8)
                                .padding(.horizontal) // Padding for image within the tab
                                .accessibilityLabel("Flag image for \(currency) - \(imageName)")
                        } else {
                            Image(systemName: "flag.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, maxHeight: 250)
                                .foregroundColor(.gray)
                                .cornerRadius(15)
                                .shadow(radius: 8)
                                .padding(.horizontal)
                                .accessibilityLabel("Placeholder flag image for \(currency)")
                        }
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always)) // Enable page-style scrolling with dots
            .indexViewStyle(.page(backgroundDisplayMode: .always)) // Ensure dots are always visible
            .frame(height: 300) // Fixed height for the TabView container
            
            // Information Card about the currency
            VStack(alignment: .leading, spacing: 10) {
                Text("About \(currency)")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                Text(currencyInfo)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            .padding()
            .background(Color(.systemGray6)) // Card background
            .cornerRadius(15)
            .shadow(radius: 5)
            .padding(.horizontal) // Padding for the info card itself
            
            Spacer()
        }
        .navigationBarHidden(true) // Hide default navigation bar
    }
}







