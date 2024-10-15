//
//  KeyboardResponder.swift
//  Currency Convert
//
//  Created by Oncu Can on 9.10.2024.
//

import SwiftUI
import Combine

final class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        let keyboardWillShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { notification -> CGFloat? in
                (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height
            }

        let keyboardWillHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ -> CGFloat in 0 }

        // Merge the two publishers to observe both keyboard show and hide events
        keyboardWillShow.merge(with: keyboardWillHide)
            .sink { [weak self] height in
                withAnimation(.easeOut(duration: 0.3)) {
                    self?.currentHeight = height
                }
            }
            .store(in: &cancellableSet)
    }
}


