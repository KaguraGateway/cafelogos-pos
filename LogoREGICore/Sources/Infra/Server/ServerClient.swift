//
//  ServerClient.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/11.
//

import Foundation
import Dependencies
import cafelogos_grpc

public struct ServerClient {
    @Dependency(\.grpcClient) private var grpcClient
    
    public func GetPosClient() -> Cafelogos_Pos_PosServiceClient {
        return Cafelogos_Pos_PosServiceClient(client: self.grpcClient)
    }
}
