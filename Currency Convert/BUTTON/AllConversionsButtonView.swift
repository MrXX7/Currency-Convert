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
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: {
            withAnimation {
                showAllConversions.toggle()
            }
        }) {
            HStack {
                Image(systemName: "globe")
                    .font(.system(size: 14))
                Text("All Conversions")
                    .font(.system(size: 14))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 15)
            .background(showAllConversions ?
                       (colorScheme == .dark ? Color.blue.opacity(0.7) : Color.blue) :
                       Color(UIColor.systemGray6))
            .foregroundColor(showAllConversions ? .white : (colorScheme == .dark ? .white : .black))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            .opacity(euroAmount.isEmpty ? 0.5 : 1)
        }
        .disabled(euroAmount.isEmpty)
    }
}
