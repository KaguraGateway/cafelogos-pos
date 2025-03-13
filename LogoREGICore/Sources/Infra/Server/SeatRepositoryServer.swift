//
//  SeatRepositoryServer.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/15.
//

import Foundation
import cafelogos_grpc

public struct SeatRepositoryServer: SeatRepository {
    // Use computed property to get a fresh client each time
    private var posClient: Cafelogos_Pos_PosServiceClient {
        return ServerClient().GetPosClient()
    }
    
    public func findAll() async -> [Seat] {
        let response = await posClient.getSeats(request: Cafelogos_Common_Empty(), headers: [:])
        if(response.message == nil) {
            return [Seat]()
        }
        return response.message!.seats.map {
            Seat(id: $0.id, name: $0.name)
        }
    }
}
