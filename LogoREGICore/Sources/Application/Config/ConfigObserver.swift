//
//  ConfigObserver.swift
//  cafelogos-pos
//
//  Created by Devin AI on 2025/03/13.
//

import Foundation
import Dependencies

public protocol ConfigObserverProtocol {
    func startObserving()
    func stopObserving()
}

public final class ConfigObserver: ConfigObserverProtocol {
    private var cancellable: Any?
    
    public init() {}
    
    public func startObserving() {
        setupObserver()
    }
    
    public func stopObserving() {
        if let cancellable = cancellable {
            NotificationCenter.default.removeObserver(cancellable)
            self.cancellable = nil
        }
    }
    
    private func setupObserver() {
        cancellable = NotificationCenter.default.addObserver(
            forName: .configChanged,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let hostUrl = notification.userInfo?["hostUrl"] as? String else { return }
            self?.updateGrpcClient(with: hostUrl)
        }
    }
    
    private func updateGrpcClient(with hostUrl: String) {
        guard !hostUrl.isEmpty else { return }
        
        // 設定が変更されたことを通知するだけ
        // 各サービスは自身でServerClientを作成するときに最新の設定を使用する
        print("Config hostUrl updated to: \(hostUrl)")
    }
    
    deinit {
        stopObserving()
    }
}
