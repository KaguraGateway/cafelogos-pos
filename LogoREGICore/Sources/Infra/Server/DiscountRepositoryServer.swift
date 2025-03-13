//
//  DiscountRepositoryServer.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/11.
//

import Foundation
import cafelogos_grpc

public struct DiscountRepositoryServer: DiscountRepository {
    // Use computed property to get a fresh client each time
    private var posClient: Cafelogos_Pos_PosServiceClient {
        return ServerClient().GetPosClient()
    }
    
    public func findAll() async -> Array<Discount> {
        let protoDiscounts = await posClient.getDiscounts(request: Cafelogos_Common_Empty(), headers: [:])
        if(protoDiscounts.message == nil) {
            return [Discount]()
        }
        return protoDiscounts.message!.discounts.map {
            // TODO: discountType, createdAt, updatedAtを修正
            Discount(
                name: $0.name,
                id: $0.id,
                discountType: DiscountType.price,
                discountPrice: Int($0.discountPrice),
                createdAt: Date(),
                updatedAt: Date(),
                syncAt: Date()
            )
        }
    }
}
