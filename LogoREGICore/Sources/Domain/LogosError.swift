//
//  Error.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/18.
//

import Foundation

enum LogosError: Error {
    case notCanBuy
    case invalidPayment
    case notEnoughAmount
}
