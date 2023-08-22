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
                ProductDto(productName: "ハレノヒブレンド", productId: UUID().uuidString, productType: ProductType.coffee, amount: 0, isNowSales: true, coffeeBean: coffeeBean, coffeeHowToBrews: [
                    CoffeeHowToBrewDto(name: "ネル", id: UUID().uuidString, price: 300, beanQuantityGrams: 100),
                    CoffeeHowToBrewDto(name: "サイフォン", id: UUID().uuidString, price: 400, beanQuantityGrams: 100),
                    CoffeeHowToBrewDto(name: "ペーパー", id: UUID().uuidString, price: 600, beanQuantityGrams: 100)
                ]),
                ProductDto(productName: "ハルメリアブレンド", productId: UUID().uuidString, productType: ProductType.coffee, amount: 0, isNowSales: true, coffeeBean: coffeeBean, coffeeHowToBrews: [
                    CoffeeHowToBrewDto(name: "ネル", id: UUID().uuidString, price: 400, beanQuantityGrams: 100),
                    CoffeeHowToBrewDto(name: "サイフォン", id: UUID().uuidString, price: 500, beanQuantityGrams: 100),
                    CoffeeHowToBrewDto(name: "ペーパー", id: UUID().uuidString, price: 700, beanQuantityGrams: 100)
                ]),
                ProductDto(productName: "アイスブレンド", productId: UUID().uuidString, productType: ProductType.coffee, amount: 0, isNowSales: true, coffeeBean: coffeeBean, coffeeHowToBrews: [
                    CoffeeHowToBrewDto(name: "アイス", id: UUID().uuidString, price: 10000, beanQuantityGrams: 100)
                ])
            ]),
            ProductCategoryDto(id: UUID().uuidString, name: "ソフトドリンク", products: [
                ProductDto(productName: "レモネード", productId: UUID().uuidString, productType: ProductType.other, amount: 500, isNowSales: true, stock: StockDto(name: "レモネード", id: UUID().uuidString, quantity: 100)),
                ProductDto(productName: "レモンスカッシュ", productId: UUID().uuidString, productType: ProductType.other, amount: 500, isNowSales: true, stock: StockDto(name: "レモンスカッシュ", id: UUID().uuidString, quantity: 100)),
                ProductDto(productName: "カルピス", productId: UUID().uuidString, productType: ProductType.other, amount: 500, isNowSales: true, stock: StockDto(name: "カルピス", id: UUID().uuidString, quantity: 100)),
                ProductDto(productName: "カルピスソーダ", productId: UUID().uuidString, productType: ProductType.other, amount: 500, isNowSales: true, stock: StockDto(name: "カルピスソーダ", id: UUID().uuidString, quantity: 100))
            ]),
            ProductCategoryDto(id: UUID().uuidString, name: "その他", products: [
                ProductDto(productName: "パン", productId: UUID().uuidString, productType: ProductType.other, amount: 100, isNowSales: true, stock: StockDto(name: "パン", id: UUID().uuidString, quantity: 100)),
                ProductDto(productName: "ケーキ", productId: UUID().uuidString, productType: ProductType.other, amount: 10000, isNowSales: true, stock: StockDto(name: "ケーキ", id: UUID().uuidString, quantity: 100)),
            ])
        ]
    }
}
