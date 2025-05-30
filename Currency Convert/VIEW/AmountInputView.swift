//
//  AmountInputView.swift
//  Currency Convert
//
//  Created by Oncu Can on 6.12.2023.
//

import SwiftUI

struct AmountInputView: View {
    @Binding var euroAmount: String
    // State to control focus on the TextField
    @FocusState private var isInputActive: Bool
    
    var body: some View {
        HStack {
            TextField("Enter Amount", text: $euroAmount)
                .keyboardType(.decimalPad)
                .font(.headline)
                .focused($isInputActive) // Apply focus state
                .onChange(of: euroAmount) { newValue in
                    // Allow only numbers and a single decimal separator (dot or comma)
                    let filtered = newValue.filter { "0123456789,.".contains($0) }
                    
                    // Replace comma with dot for consistent double conversion
                    let standardized = filtered.replacingOccurrences(of: ",", with: ".")
                    
                    // Ensure only one decimal point
                    if standardized.components(separatedBy: ".").count > 2 {
                        let parts = standardized.components(separatedBy: ".")
                        euroAmount = parts[0] + "." + parts.dropFirst().joined()
                    } else {
                        euroAmount = standardized
                    }
                    
                    // Optional: Limit to a reasonable number of decimal places (e.g., 4)
                    if let decimalIndex = euroAmount.firstIndex(of: ".") {
                        let afterDecimal = euroAmount.suffix(from: euroAmount.index(after: decimalIndex))
                        if afterDecimal.count > 4 { // Adjust as needed
                            euroAmount = String(euroAmount.prefix(upTo: euroAmount.index(decimalIndex, offsetBy: 5)))
                        }
                    }
                }
            
            if !euroAmount.isEmpty {
                Button(action: {
                    euroAmount = ""
                    // Dismiss keyboard when amount is cleared
                    isInputActive = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(height: 35) // Fixed height for consistency
        .frame(maxWidth: .infinity) // Max width for proper alignment
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                // Dynamically change border color based on focus
                .stroke(isInputActive ? Color.accentColor : Color.gray.opacity(0.3), lineWidth: isInputActive ? 2 : 1)
        )
        .animation(.easeOut(duration: 0.2), value: isInputActive) // Animate border color change
        .onAppear {
            // Automatically focus the text field when the view appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Small delay to ensure view is ready
                self.isInputActive = true
            }
        }
        // Dismiss keyboard when tapping outside
        .contentShape(Rectangle()) // Make the entire VStack tappable for dismissing keyboard
        .onTapGesture {
            isInputActive = false // Dismiss keyboard
        }
    }
}


