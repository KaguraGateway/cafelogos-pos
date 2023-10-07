//
//  ProductMock.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/20.
//

import Foundation

public struct ProductQueryServiceMock: ProductQueryService {
    public func fetchProducts() -> Array<ProductCategoryDto> {
        let coffeeBean = CoffeeBeanDto(id: UUID().uuidString, name: "コーヒー豆", gramQuantity: 1000)
        return [
            ProductCategoryDto(id: UUID().uuidString, name: "コーヒー", products: [
                ProductDto(productName: "ロゴスブレンド豊穣", productId: UUID().uuidString, productType: ProductType.coffee, amount: 0, isNowSales: true, coffeeBean: coffeeBean, coffeeHowToBrews: [
                    CoffeeHowToBrewDto(name: "ネル", id: UUID().uuidString, price: 300, beanQuantityGrams: 100),
                    CoffeeHowToBrewDto(name: "サイフォン", id: UUID().uuidString, price: 400, beanQuantityGrams: 100),
                    CoffeeHowToBrewDto(name: "ペーパー", id: UUID().uuidString, price: 600, beanQuantityGrams: 100)
                ]),
                ProductDto(productName: "茜ブレンド", productId: UUID().uuidString, productType: ProductType.coffee, amount: 0, isNowSales: true, coffeeBean: coffeeBean, coffeeHowToBrews: [
                    CoffeeHowToBrewDto(name: "ネル", id: UUID().uuidString, price: 400, beanQuantityGrams: 100),
                    CoffeeHowToBrewDto(name: "サイフォン", id: UUID().uuidString, price: 500, beanQuantityGrams: 100),
                    CoffeeHowToBrewDto(name: "ペーパー", id: UUID().uuidString, price: 700, beanQuantityGrams: 100)
                ])
            ]),
            ProductCategoryDto(id: UUID().uuidString, name: "ソフトドリンク", products: [
                ProductDto(productName: "レモネード", productId: UUID().uuidString, productType: ProductType.other, amount: 200, isNowSales: true, stock: StockDto(name: "レモネード", id: UUID().uuidString, quantity: 100)),
                ProductDto(productName: "レモネードスカッシュ", productId: UUID().uuidString, productType: ProductType.other, amount: 200, isNowSales: true, stock: StockDto(name: "レモンスカッシュ", id: UUID().uuidString, quantity: 100)),
                ProductDto(productName: "ヨーグルッペ", productId: UUID().uuidString, productType: ProductType.other, amount: 100, isNowSales: true, stock: StockDto(name: "ヨーグルッペ", id: UUID().uuidString, quantity: 100)),
                ProductDto(productName: "ヨーグルッペ（日向夏）", productId: UUID().uuidString, productType: ProductType.other, amount: 100, isNowSales: true, stock: StockDto(name: "ヨーグルッペ", id: UUID().uuidString, quantity: 100)),
            ]),
            ProductCategoryDto(id: UUID().uuidString, name: "その他", products: [
                ProductDto(productName: "薄皮饅頭", productId: UUID().uuidString, productType: ProductType.other, amount: 200, isNowSales: true, stock: StockDto(name: "パン", id: UUID().uuidString, quantity: 100)),
                ProductDto(productName: "チョコレート", productId: UUID().uuidString, productType: ProductType.other, amount: 0, isNowSales: true, stock: StockDto(name: "ケーキ", id: UUID().uuidString, quantity: 100)),
            ])
        ]
    }
}
