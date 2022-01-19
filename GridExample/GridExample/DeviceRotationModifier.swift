//
//  DeviceRotationModifier.swift
//  GridExample
//
//  Created by Alexander Kraev on 19.01.2022.
//

import SwiftUI

struct DeviceRotationModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}
// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationModifier(action: action))
    }
}
