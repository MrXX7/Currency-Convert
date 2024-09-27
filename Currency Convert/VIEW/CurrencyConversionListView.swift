//
//  CurrencyConversionListView.swift
//  Currency Convert
//
//  Created by Oncu Can on 27.09.2024.
//

import SwiftUI

struct CurrencyConversionListView: View {
    let conversions: [String]
    
    var body: some View {
        ForEach(conversions, id: \.self) { result in
            Text(result)
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
                .padding(.horizontal) // Add padding to both sides for symmetry
        }
    }
}
