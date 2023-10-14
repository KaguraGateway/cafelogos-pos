//
//  GetSeats.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/15.
//

import Foundation
import Dependencies

public struct GetSeats {
    @Dependency(\.serverSeatRepository) private var seatRepo;
    
    func Execute() async -> Array<Seat> {
        return await seatRepo.findAll()
    }
}
