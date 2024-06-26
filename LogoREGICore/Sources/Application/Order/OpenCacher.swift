//
//  OpenCacher.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/12.
//

import Foundation
import Dependencies

public struct OpenCacher {
    @Dependency(\.orderReceipt) var orderReceiptService
    
    public init() {}
    
    public func Execute() -> String {
        return orderReceiptService.openCacher()
    }
}
