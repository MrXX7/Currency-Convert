//
//  ResetButton.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import SwiftUI

struct ResetButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label("Reset", systemImage: "arrow.counterclockwise")
        }
        .buttonStyle(SecondaryCapsuleButtonStyle())
    }
}
