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
        HStack {
            Text("Total Amount: \(convertedAmount, specifier: "%.2f") \(selectedCurrency)")
                .padding(.vertical)
                .font(.title2)
            Spacer()
        }
    }
}
