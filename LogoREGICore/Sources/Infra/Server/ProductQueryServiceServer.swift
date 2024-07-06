//
//  ProductServer.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/10.
//

import Foundation
import Dependencies
import cafelogos_grpc

public struct ProductQueryServiceServer: ProductQueryService {
    

    private let posClient = ServerClient().GetPosClient()
    private var formatter = ISO8601DateFormatter()

    public func fetchProductCategoriesWithProducts() async -> Array<ProductCatalogDto> {
        let response = await self.posClient.getProducts(request: Cafelogos_Common_Empty(), headers: [:])
        if(response.message == nil) {
            return [ProductCatalogDto]()
        }
        let protoProducts = response.message!.products
        // Key: CategoryId
        var products = [String: Array<ProductDto>]()
        
        // 取り出す
        for product in protoProducts {
            let categoryId = product.productCategory.id
            if(products[categoryId] == nil) {
                products[categoryId] = [ProductDto]()
            }
            
            products[categoryId]?.append(ProductDto(
                productName: product.productName,
                productId: product.productID,
                productCategory: ProductCategoryDto(
                    id: product.productCategory.id,
                    name: product.productCategory.name,
                    createdAt: formatter.date(from: product.productCategory.createdAt)!,
                    updatedAt: formatter.date(from: product.productCategory.updatedAt)!
                ),
                productType: ProductType(rawValue: product.productType.rawValue)!,
                amount: product.amount,
                isNowSales: product.isNowSales,
                createdAt: formatter.date(from: product.createdAt)!,
                updatedAt: formatter.date(from: product.updatedAt)!,
                stock: product.hasStock ? StockDto(
                    name: product.stock.name,
                    id: product.stock.id,
                    quantity: Int32(product.stock.quantity),
                    createdAt: formatter.date(from: product.stock.createdAt)!,
                    updatedAt: formatter.date(from: product.stock.updatedAt)!
                ) : nil,
                coffeeBean: product.hasCoffeeBean ? CoffeeBeanDto(
                    id: product.coffeeBean.id,
                    name: product.coffeeBean.name,
                    gramQuantity: product.coffeeBean.gramQuantity,
                    createdAt: formatter.date(from: product.coffeeBean.createdAt)!,
                    updatedAt: formatter.date(from: product.coffeeBean.updatedAt)!
                ) : nil,
                coffeeHowToBrews: product.coffeeBrews.map {
                    CoffeeHowToBrewDto(name: $0.name, id: $0.id, amount: $0.amount, beanQuantityGrams: $0.beanQuantityGrams, createdAt: formatter.date(from: $0.createdAt)!, updatedAt: formatter.date(from: $0.updatedAt)!)
                }
            ))
        }
        
        // ProductCategoryWithProductsDtoへ
        var categories = [ProductCatalogDto]()
        for (_, productDtos) in products {
            categories.append(ProductCatalogDto(
                id: productDtos[0].productCategory.id,
                name: productDtos[0].productCategory.name,
                createdAt: productDtos[0].productCategory.createdAt,
                updatedAt: productDtos[0].productCategory.updatedAt,
                products: productDtos
            ))
        }
        categories.sort { $0.createdAt < $1.createdAt }
        
        return categories
    }
}
