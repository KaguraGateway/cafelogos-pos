//
//  cafelogos_posTests.swift
//  cafelogos-posTests
//
//  Created by ygates on 2023/08/08.
//

import XCTest
@testable import cafelogos_pos

final class CartTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // Coffee
    let coffeeBean = CoffeeBean(id: UUID().uuidString, name: "コーヒー豆", amountGrams: 1000)
    // 淹れ方がそれぞれあるので
    let flannnel = CoffeeHowToBrew(name: "ネル", id: UUID().uuidString, beanQuantityGrams: 100, price: 500)
    let siphon = CoffeeHowToBrew(name: "サイフォン", id: UUID().uuidString, beanQuantityGrams: 100, price: 1000)
    let paper = CoffeeHowToBrew(name: "ペーパー", id: UUID().uuidString, beanQuantityGrams: 100, price: 1500)
    let ice = CoffeeHowToBrew(name: "アイス", id: UUID().uuidString, beanQuantityGrams: 100, price: 1500)
    // Pan
    let pan = OtherProduct(productName: "パン", productId: UUID().uuidString, productCategory: ProductCategory(name: "その他", id: UUID().uuidString), price: 100, stock: Stock(name: "パン", id: UUID().uuidString, amount: 100), isNowSales: true)

    func testCoffee() throws {
        // 各種コーヒを用意
        let coffee1 = CoffeeProduct(productName: "ハレノヒブレンド", productId: UUID().uuidString, coffeeBean: coffeeBean, coffeeHowToBrews: [self.flannnel, self.siphon, self.paper], isNowSales: true)
        let coffee2 = CoffeeProduct(productName: "アイスブレンド", productId: UUID().uuidString, coffeeBean: coffeeBean, coffeeHowToBrews: [self.ice], isNowSales: true)
        // 全種類のコーヒ買う（通常系）
        let cart = Cart(items: [
            // ハレノヒ・ネル
            try CartItem(coffee: coffee1, brew: flannnel, amount: 1),
            // ハレノヒ・サイフォン
            try CartItem(coffee: coffee1, brew: siphon, amount: 1),
            // ハレノヒ・ペーパー
            try CartItem(coffee: coffee1, brew: paper, amount: 1),
            // アイス・アイス
            try CartItem(coffee: coffee2, brew: ice, amount: 5),
        ])
        // お値段の計算ができるかどうか
        XCTAssertEqual(cart.getTotalPrice(), 10500) // 3000 + 5 * 1500
        // 購入できるはず
        XCTAssertTrue(cart.getItems().allSatisfy({$0.canBuy()}))
        
        // 淹れ方が存在しないものを指定する（エラーが発生しなければならない）
        XCTAssertThrowsError(try CartItem(coffee: coffee1, brew: ice, amount: 1))
        
        // 豆の数量不足で購入不可扱いになるはず
        let ice2 = CoffeeHowToBrew(name: "アイス", id: UUID().uuidString, beanQuantityGrams: 2000, price: 1500)
        let coffee3 = CoffeeProduct(productName: "ハルメリアブレンド", productId: UUID().uuidString, coffeeBean: coffeeBean, coffeeHowToBrews: [ice2], isNowSales: false)
        XCTAssertFalse((try CartItem(coffee: coffee1, brew: paper, amount: 11)).canBuy())
        XCTAssertFalse((try CartItem(coffee: coffee3, brew: ice2, amount: 1)).canBuy())
    }
    
    func testOtherProduct() throws {
        let cart = Cart(items: [
            CartItem(product: pan, amount: 50)
        ])
        // お値段の計算ができるかどうか
        XCTAssertEqual(cart.getTotalPrice(), 5000)
        // 購入できるはず
        XCTAssertTrue(cart.getItems().allSatisfy({$0.canBuy()}))

        // 豆の数量不足で購入不可扱いになるはず
        XCTAssertFalse(CartItem(product: pan, amount: 101).canBuy())
    }
    
    func testMultipleCart() throws {
        // 各種コーヒを用意
        let coffee1 = CoffeeProduct(productName: "ハレノヒブレンド", productId: UUID().uuidString, coffeeBean: coffeeBean, coffeeHowToBrews: [self.flannnel, self.siphon, self.paper], isNowSales: true)
        let coffee2 = CoffeeProduct(productName: "アイスブレンド", productId: UUID().uuidString, coffeeBean: coffeeBean, coffeeHowToBrews: [self.ice], isNowSales: true)
        let cart = Cart(items: [
            // ハレノヒ・ネル
            try CartItem(coffee: coffee1, brew: flannnel, amount: 1),
            // ハレノヒ・サイフォン
            try CartItem(coffee: coffee1, brew: siphon, amount: 1),
            // ハレノヒ・ペーパー
            try CartItem(coffee: coffee1, brew: paper, amount: 1),
            // アイス・アイス
            try CartItem(coffee: coffee2, brew: ice, amount: 5),
            CartItem(product: pan, amount: 50)
        ])
        // お値段の計算ができるかどうか
        XCTAssertEqual(cart.getTotalPrice(), 15500)
        // 購入できるはず
        XCTAssertTrue(cart.getItems().allSatisfy({$0.canBuy()}))
    }
    
    func testChangeCart() throws {
        // 要素数ゼロのカートを用意
        var cart = Cart()
        XCTAssertEqual(cart.getItems().count, 0)
        // 各種コーヒを用意
        let coffee1 = CoffeeProduct(productName: "ハレノヒブレンド", productId: UUID().uuidString, coffeeBean: coffeeBean, coffeeHowToBrews: [self.flannnel, self.siphon, self.paper], isNowSales: true)
        let coffee2 = CoffeeProduct(productName: "ハルメリアブレンド", productId: UUID().uuidString, coffeeBean: coffeeBean, coffeeHowToBrews: [self.flannnel, self.siphon, self.paper], isNowSales: true)
        // カートに追加
        let cartItem = try CartItem(coffee: coffee1, brew: flannnel, amount: 1)
        cart.addItem(newItem: cartItem)
        XCTAssertEqual(cart.getItems().count, 1)
        XCTAssertEqual(cart.totalAmount, 1)
        // カートに追加済みのアイテムの数量を変更すると注文品数が変わる
        cart.setItemAmount(itemIndex: 0, newAmount: 2)
        XCTAssertEqual(cart.totalAmount, 2)
        // 同じ商品、同じ淹れ方の商品を追加してもカート内の配列数は変わらない
        cart.addItem(newItem: try CartItem(coffee: coffee1, brew: flannnel, amount: 2))
        XCTAssertEqual(cart.getItems().count, 1)
        XCTAssertEqual(cart.totalAmount, 4) // 注文品数だけが増えるはず
        // 同じ商品、違う淹れ方の商品を追加するとカート内の配列数が増える
        cart.addItem(newItem: try CartItem(coffee: coffee1, brew: paper, amount: 1))
        XCTAssertEqual(cart.getItems().count, 2)
        XCTAssertEqual(cart.totalAmount, 5)
        // 違う商品を追加するとカート内の配列数が増える
        cart.addItem(newItem: try CartItem(coffee: coffee2, brew: flannnel, amount: 1))
        XCTAssertEqual(cart.getItems().count, 3)
        XCTAssertEqual(cart.totalAmount, 6)
        // 商品を削除すると消えるはず
        cart.removeItem(removeItem: cartItem)
        XCTAssertEqual(cart.getItems().count, 2)
        XCTAssertEqual(cart.totalAmount, 2)
        // 商品全削除すると0になるはず
        cart.removeAllItem()
        XCTAssertEqual(cart.getItems().count, 0)
        XCTAssertEqual(cart.totalAmount, 0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
