//
//  ResetButton.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import SwiftUI
import UIKit

struct ResetButton: View {
    let action: () -> Void

    var body: some View {
        Button {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            action()
        } label: {
            Label("Reset", systemImage: "arrow.counterclockwise")
        }
        .buttonStyle(SecondaryCapsuleButtonStyle())
    }
}
