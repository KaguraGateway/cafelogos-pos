//
//  ProductMock.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/20.
//

import Foundation

public struct ProductQueryServiceMock: ProductQueryService {
    
    public init() {}
    
    public func fetchProductCategoriesWithProducts() async -> Array<ProductCatalogDto> {
        let coffeeBean = CoffeeBeanDto(id: UUID().uuidString, name: "コーヒー豆", gramQuantity: 1000, createdAt: Date(), updatedAt: Date())
        let coffeeCategory = ProductCategoryDto(id: UUID().uuidString, name: "コーヒー", createdAt: Date(), updatedAt: Date())
        let softCategory = ProductCategoryDto(id: UUID().uuidString, name: "ソフトドリンク", createdAt: Date(), updatedAt: Date())
        let otherCategory = ProductCategoryDto(id: UUID().uuidString, name: "その他", createdAt: Date(), updatedAt: Date())
        
        return [
            ProductCatalogDto(id: UUID().uuidString, name: "コーヒー", createdAt: Date(), updatedAt: Date(), products: [
                ProductDto(productName: "ロゴスブレンド豊穣", productId: UUID().uuidString, productCategory: coffeeCategory, productType: ProductType.coffee, amount: 0, isNowSales: true, createdAt: Date(), updatedAt: Date(), coffeeBean: coffeeBean, coffeeHowToBrews: [
                    CoffeeHowToBrewDto(name: "ネル", id: UUID().uuidString, amount: 300, beanQuantityGrams: 100, createdAt: Date(), updatedAt: Date()),
                    CoffeeHowToBrewDto(name: "サイフォン", id: UUID().uuidString, amount: 400, beanQuantityGrams: 100, createdAt: Date(), updatedAt: Date()),
                    CoffeeHowToBrewDto(name: "ペーパー", id: UUID().uuidString, amount: 600, beanQuantityGrams: 100, createdAt: Date(), updatedAt: Date())
                ]),
                ProductDto(productName: "茜ブレンド", productId: UUID().uuidString, productCategory: coffeeCategory, productType: ProductType.coffee, amount: 0, isNowSales: true, createdAt: Date(), updatedAt: Date(), coffeeBean: coffeeBean, coffeeHowToBrews: [
                    CoffeeHowToBrewDto(name: "ネル", id: UUID().uuidString, amount: 400, beanQuantityGrams: 100, createdAt: Date(), updatedAt: Date()),
                    CoffeeHowToBrewDto(name: "サイフォン", id: UUID().uuidString, amount: 500, beanQuantityGrams: 100, createdAt: Date(), updatedAt: Date()),
                    CoffeeHowToBrewDto(name: "ペーパー", id: UUID().uuidString, amount: 700, beanQuantityGrams: 100, createdAt: Date(), updatedAt: Date())
                ]),
                ProductDto(productName: "logos Honduras", productId: UUID().uuidString, productCategory: coffeeCategory, productType: ProductType.coffee, amount: 0, isNowSales: true, createdAt: Date(), updatedAt: Date(), coffeeBean: coffeeBean, coffeeHowToBrews: [
                    CoffeeHowToBrewDto(name: "ネル", id: UUID().uuidString, amount: 400, beanQuantityGrams: 100, createdAt: Date(), updatedAt: Date()),
                    CoffeeHowToBrewDto(name: "サイフォン", id: UUID().uuidString, amount: 500, beanQuantityGrams: 100, createdAt: Date(), updatedAt: Date()),
                    CoffeeHowToBrewDto(name: "ペーパー", id: UUID().uuidString, amount: 700, beanQuantityGrams: 100, createdAt: Date(), updatedAt: Date()),
                    CoffeeHowToBrewDto(name: "マキネッタ（アメリカーノ）", id: UUID().uuidString, amount: 500, beanQuantityGrams: 100, createdAt: Date(), updatedAt: Date()),
                    CoffeeHowToBrewDto(name: "マキネッタ（ロングブラック）", id: UUID().uuidString, amount: 500, beanQuantityGrams: 100, createdAt: Date(), updatedAt: Date()),
                    CoffeeHowToBrewDto(name: "マキネッタ（エスプレッソ）", id: UUID().uuidString, amount: 500, beanQuantityGrams: 100, createdAt: Date(), updatedAt: Date()),
                    CoffeeHowToBrewDto(name: "フレンチプレス", id: UUID().uuidString, amount: 500, beanQuantityGrams: 100, createdAt: Date(), updatedAt: Date()),
                    CoffeeHowToBrewDto(name: "コールドブリュー", id: UUID().uuidString, amount: 500, beanQuantityGrams: 100, createdAt: Date(), updatedAt: Date()),
                    CoffeeHowToBrewDto(name: "アイスブリュー", id: UUID().uuidString, amount: 500, beanQuantityGrams: 100, createdAt: Date(), updatedAt: Date()),
                ])
            ]),
            ProductCatalogDto(id: UUID().uuidString, name: "ソフトドリンク", createdAt: Date(), updatedAt: Date(), products: [
                ProductDto(productName: "レモネード", productId: UUID().uuidString, productCategory: softCategory, productType: ProductType.other, amount: 200, isNowSales: true, createdAt: Date(), updatedAt: Date(), stock: StockDto(name: "レモネード", id: UUID().uuidString, quantity: 100, createdAt: Date(), updatedAt: Date())),
                ProductDto(productName: "レモネードスカッシュ", productId: UUID().uuidString, productCategory: softCategory, productType: ProductType.other, amount: 200, isNowSales: true, createdAt: Date(), updatedAt: Date(), stock: StockDto(name: "レモンスカッシュ", id: UUID().uuidString, quantity: 100, createdAt: Date(), updatedAt: Date())),
                ProductDto(productName: "ヨーグルッペ", productId: UUID().uuidString, productCategory: softCategory, productType: ProductType.other, amount: 100, isNowSales: true, createdAt: Date(), updatedAt: Date(), stock: StockDto(name: "ヨーグルッペ", id: UUID().uuidString, quantity: 100, createdAt: Date(), updatedAt: Date())),
                ProductDto(productName: "ヨーグルッペ（日向夏）", productId: UUID().uuidString, productCategory: softCategory, productType: ProductType.other, amount: 100, isNowSales: true, createdAt: Date(), updatedAt: Date(), stock: StockDto(name: "ヨーグルッペ", id: UUID().uuidString, quantity: 100, createdAt: Date(), updatedAt: Date())),
            ]),
            ProductCatalogDto(id: UUID().uuidString, name: "その他", createdAt: Date(), updatedAt: Date(), products: [
                ProductDto(productName: "薄皮饅頭", productId: UUID().uuidString, productCategory: otherCategory, productType: ProductType.other, amount: 200, isNowSales: true, createdAt: Date(), updatedAt: Date(), stock: StockDto(name: "パン", id: UUID().uuidString, quantity: 100, createdAt: Date(), updatedAt: Date())),
                ProductDto(productName: "チョコレート", productId: UUID().uuidString, productCategory: otherCategory, productType: ProductType.other, amount: 0, isNowSales: true, createdAt: Date(), updatedAt: Date(), stock: StockDto(name: "ケーキ", id: UUID().uuidString, quantity: 100, createdAt: Date(), updatedAt: Date())),
            ])
        ]
    }
}
