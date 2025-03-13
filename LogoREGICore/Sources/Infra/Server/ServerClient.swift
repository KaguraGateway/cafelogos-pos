//
//  ServerClient.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/11.
//

import Foundation
import Dependencies
import cafelogos_grpc
import Connect

public struct ServerClient {
    // 依存関係を直接取得せず、毎回最新の設定を取得する
    public func GetPosClient() -> Cafelogos_Pos_PosServiceClient {
        // 依存関係から最新の設定を取得
        var config: Config!
        withDependencies { dependencies in
            config = dependencies.configRepository.load()
        } operation: {
            // 空のオペレーション
        }
        
        // 設定から直接クライアントを作成
        let hostUrl = config.hostUrl.isEmpty ? "http://localhost:8080" : config.hostUrl
        let client = ProtocolClient(
            httpClient: URLSessionHTTPClient(),
            config: ProtocolClientConfig(
                host: hostUrl,
                networkProtocol: .connect,
                codec: ProtoCodec()
            )
        )
        return Cafelogos_Pos_PosServiceClient(client: client)
    }
}
