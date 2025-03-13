//
//  ConfigObserver.swift
//  cafelogos-pos
//
//  Created by Devin AI on 2025/03/13.
//

import Foundation
import Dependencies

public final class ConfigObserver {
    private var cancellable: Any?
    
    public static let shared = ConfigObserver()
    
    private init() {
        setupObserver()
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
        
        // withDependenciesを使用して、グローバルにgRPCクライアントを更新
        DependencyValues.withValues { values in
            values.grpcClient = GrpcClientKey.createClient(hostUrl: hostUrl)
        }
    }
    
    deinit {
        if let cancellable = cancellable {
            NotificationCenter.default.removeObserver(cancellable)
        }
    }
}
