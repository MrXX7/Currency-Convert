//
//  TotalAmountView.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import SwiftUI

struct TotalAmountView: View {
    var convertedAmount: Double
    var selectedCurrency: String
    
    var body: some View {
        Text("\(convertedAmount, specifier: "%.2f") \(selectedCurrency)")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundColor(convertedAmount >= 0 ? .green : .red)
            .padding(8)
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .shadow(radius: 3) 
    }
}



