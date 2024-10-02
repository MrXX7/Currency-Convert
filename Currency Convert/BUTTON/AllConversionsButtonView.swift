//
//  AllConversionsButtonView.swift
//  Currency Convert
//
//  Created by Oncu Can on 1.10.2024.
//

import SwiftUI

struct AllConversionsButtonView: View {
    @Binding var showAllConversions: Bool
    @Binding var euroAmount: String
    
    var body: some View {
        Button(action: {
            showAllConversions.toggle()
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }) {
            HStack {
                Image(systemName: "globe")
                Text("All Conversions")
                    .font(.footnote)
            }
        }
        .frame(maxWidth: .infinity)
        .disabled(euroAmount.isEmpty || euroAmount == "0")
    }
}
