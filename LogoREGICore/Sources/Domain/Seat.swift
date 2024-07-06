//
//  Seat.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/15.
//

import Foundation

public struct Seat: Equatable {
    public let id: String
    public let name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

protocol SeatRepository {
    func findAll() async -> [Seat]
}
