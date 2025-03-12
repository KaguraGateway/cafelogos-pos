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
    public var useCashDrawer: Bool {
        get { self[UseCashDrawerKey.self] }
        set { self[UseCashDrawerKey.self] = newValue }
    }
}

private struct IsServerConnectedKey: EnvironmentKey {
    static var defaultValue: Bool { true }
}

private struct UseCashDrawerKey: EnvironmentKey {
    static var defaultValue: Bool { true }
}

private struct HostUrlKey: EnvironmentKey {
    static var defaultValue: String { "http://localhost:8080" }
}

extension EnvironmentValues {
    public var hostUrl: String {
        get { self[HostUrlKey.self] }
        set { self[HostUrlKey.self] = newValue }
    }
}
