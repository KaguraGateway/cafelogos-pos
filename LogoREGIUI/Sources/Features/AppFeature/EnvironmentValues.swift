//
//  SwiftUIView.swift
//  
//  
//  Created by　KaguraGateway on 2024/07/03
//  
//

import SwiftUI

extension EnvironmentValues {
    public var isServerConnected: Bool {
        get { self[IsServerConnectedKey.self] }
        set { self[IsServerConnectedKey.self] = newValue }
    }
}

private struct IsServerConnectedKey: EnvironmentKey {
    static var defaultValue: Bool { true }
}
