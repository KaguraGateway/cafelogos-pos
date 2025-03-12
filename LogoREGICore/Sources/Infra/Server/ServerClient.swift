//
//  ServerClient.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/11.
//

import Foundation
import Dependencies
import cafelogos_grpc
import SwiftUI

public struct ServerClient {
    @Dependency(\.grpcClient) private var grpcClient
    @Environment(\.hostUrl) private var hostUrl // EnvironmentからhostUrlを取得
    
    public func GetPosClient() -> Cafelogos_Pos_PosServiceClient {
        return Cafelogos_Pos_PosServiceClient(client: self.grpcClient)
    }
}
