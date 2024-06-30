//
//  OrderTests.swift
//  cafelogos-posTests
//
//  Created by ygates on 2023/08/19.
//

import XCTest

@testable import cafelogos_pos

final class OrderTests: XCTestCase {
    
    // Coffee
    let coffeeBean = CoffeeBean(id: UUID().uuidString, name: "コーヒー豆", gramQuantity: 1000)
    let coffeeCategory = ProductCategory(name: "コーヒー", id: UUID().uuidString)
    // 淹れ方がそれぞれあるので
    let flannnel = CoffeeHowToBrew(name: "ネル", id: UUID().uuidString, beanQuantityGrams: 100, price: 500)
    let siphon = CoffeeHowToBrew(name: "サイフォン", id: UUID().uuidString, beanQuantityGrams: 100, price: 1000)
    let paper = CoffeeHowToBrew(name: "ペーパー", id: UUID().uuidString, beanQuantityGrams: 100, price: 1500)
    let ice = CoffeeHowToBrew(name: "アイス", id: UUID().uuidString, beanQuantityGrams: 100, price: 1500)
    // Pan
    let pan = OtherProduct(productName: "パン", productId: UUID().uuidString, productCategory: ProductCategory(name: "その他", id: UUID().uuidString), price: 100, stock: Stock(name: "パン", id: UUID().uuidString, quantity: 100), isNowSales: true)

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOrder() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        // 各種コーヒを用意
        let coffee1 = CoffeeProduct(productName: "ハレノヒブレンド", productId: UUID().uuidString, productCategory: coffeeCategory, coffeeBean: coffeeBean, coffeeHowToBrews: [self.flannnel, self.siphon, self.paper], isNowSales: true)
        let coffee2 = CoffeeProduct(productName: "アイスブレンド", productId: UUID().uuidString, productCategory: coffeeCategory, coffeeBean: coffeeBean, coffeeHowToBrews: [self.ice], isNowSales: true)
        // 全種類のコーヒ買う（通常系）
        var order1 = Order()
        order1.cart.addItem(newItem: try CartItem(coffee: coffee1, brew: flannnel, quantity: 1))
        order1.cart.addItem(newItem: try CartItem(coffee: coffee1, brew: siphon, quantity: 1))
        order1.cart.addItem(newItem: try CartItem(coffee: coffee1, brew: paper, quantity: 1))
        order1.cart.addItem(newItem: try CartItem(coffee: coffee2, brew: ice, quantity: 5))
        order1.cart.addItem(newItem: CartItem(product: pan, quantity: 10))
        XCTAssertEqual(order1.cart.totalQuantity, 18)
        XCTAssertEqual(order1.totalAmount, 11500)
        // 割引を追加する
        order1.discounts.append(Discount(name: "新入生割", id: "", discountType: DiscountType.price, discountPrice: 100))
        XCTAssertEqual(order1.totalAmount, 11400) // 100円割引されているはず
        order1.discounts.append(Discount(name: "新入生割", id: "", discountType: DiscountType.price, discountPrice: 100))
        XCTAssertEqual(order1.totalAmount, 11300) // さらに100円割引されているはず
        
        // Payment
        var payment = Payment(type: PaymentType.cash, paymentAmount: order1.totalAmount, receiveAmount: 0)
        // 不足のとき
        payment.receiveAmount = 1000
        XCTAssertFalse(payment.isEnoughAmount())
        XCTAssertEqual(payment.shortfallAmount, 10300) // まだ１０００円しか出してないので残額10300円
        // ちょうどのとき
        payment.receiveAmount = 11300
        XCTAssertTrue(payment.isEnoughAmount())
        XCTAssertEqual(payment.shortfallAmount, 0)
        XCTAssertEqual(payment.changeAmount, 0)
        // お釣りが出るとき
        payment.receiveAmount = 15000
        XCTAssertTrue(payment.isEnoughAmount())
        XCTAssertEqual(payment.shortfallAmount, 0)
        XCTAssertEqual(payment.changeAmount, 3700)
        
        // Pay
        XCTAssertNoThrow({try order1.pay(payment: payment)})
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
