//
//  OrderServiceServer.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/13.
//

import Foundation
import cafelogos_grpc
import Dependencies

public struct OrderServiceServer: OrderService {
    private let posClient = ServerClient().GetPosClient()
    private let formatter = ISO8601DateFormatter()
    
    func getUnpaidOrdersBySeatId(seatId: String) async -> [Order] {
        let req = Cafelogos_Pos_GetUnpaidOrdersBySeatIdRequest.with {
            $0.seatID = seatId
        }
        
        // TODO
        let products = await posClient.getProducts(request: Cafelogos_Common_Empty(), headers: [:])
        if products.message == nil {
            return [Order]()
        }
        
        let protoOrders = await posClient.getUnpaidOrdersBySeatID(request: req, headers: [:])
        
        return protoOrders.message?.orders.map {
            return Order(
                id: $0.id,
                cart: Cart(items: $0.items.map { item in
                    let protoProduct = products.message!.products.first { item.productID == $0.productID }
                    let category = ProductCategory(id: protoProduct!.productCategory.id, name: protoProduct!.productCategory.name, createdAt: Date(), updatedAt: Date(), syncAt: nil)
                    if protoProduct?.productType == Cafelogos_Pos_ProductType.coffee {
                        let protoCoffeeBrew = protoProduct!.coffeeBrews.first { $0.id == item.coffeeBrewID }
                        return try! CartItem(
                            coffee: CoffeeProduct(
                                productName: protoProduct!.productName,
                                productId: protoProduct!.productID,
                                productCategory: category,
                                coffeeBean: CoffeeBean(id: protoProduct!.coffeeBean.id, name: protoProduct!.coffeeBean.name, gramQuantity: protoProduct!.coffeeBean.gramQuantity, createdAt: Date(), updatedAt: Date(), syncAt: nil),
                                coffeeHowToBrews: protoProduct!.coffeeBrews.map {  CoffeeHowToBrew(name: $0.name, id: $0.id, beanQuantityGrams: $0.beanQuantityGrams, amount: $0.amount, createdAt: Date(), updatedAt: Date(), syncAt: nil)},
                                isNowSales: protoProduct!.isNowSales,
                                createdAt: Date(),
                                updatedAt: Date(),
                                syncAt: Date()),
                            brew: CoffeeHowToBrew(name: protoCoffeeBrew!.name, id: protoCoffeeBrew!.id, beanQuantityGrams: protoCoffeeBrew!.beanQuantityGrams, amount: protoCoffeeBrew!.amount, createdAt: Date(), updatedAt: Date(), syncAt: nil),
                            quantity: item.quantity)
                    }
                    return CartItem(product: OtherProduct(productName: protoProduct!.productName, productId: protoProduct!.productID, productCategory: category, price: protoProduct!.amount, stock: Stock(name: protoProduct!.stock.name, id: protoProduct!.stock.id, quantity: Int32(protoProduct!.stock.quantity), createdAt: Date(), updatedAt: Date(), syncAt: nil), isNowSales: protoProduct!.isNowSales, createdAt: Date(), updatedAt: Date(), syncAt: nil), quantity: item.quantity)
                }),
                discounts: [Discount](),
                orderAt: formatter.date(from: $0.orderAt)!
            )
        } ?? [Order]()
    }
}
