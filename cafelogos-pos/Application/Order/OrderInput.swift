//
//  OrderInput.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/08/20.
//

import Foundation

protocol OrderInput {
    func getProducts() -> Array<ProductCategoryDto>
    func getOrder() -> OrderPendingDto
    mutating func addItemToCart(product: ProductDto, productCategory: ProductCategoryDto, quantity: UInt32, brew: CoffeeHowToBrewDto?)
    mutating func increaseItemQuantity(itemIndex: Int)
    mutating func decreaseItemQuantity(itemIndex: Int)
    mutating func removeItem(removeItem: CartItemDto)
    mutating func removeAllItem()
}

public struct OrderPendingDto {
    public let id: String
    public let cart: CartDto
    public let discounts: Array<DiscountDto>
    public let totalAmount: UInt64
    
    public init(id: String, cart: CartDto, discounts: Array<DiscountDto>, totalAmount: UInt64) {
        self.id = id
        self.cart = cart
        self.discounts = discounts
        self.totalAmount = totalAmount
    }
}

public struct OrderInputUsecase: OrderInput {
    private let productQueryService: ProductQueryService
    private let discountRepository: DiscountRepository
    private var onPublishOrder: ((OrderPendingDto) -> Void)?
    private var order: Order {
        didSet {
            self.onPublishOrder?(getOrder())
        }
    }
    
    public init(productQueryService: ProductQueryService, discountRepository: DiscountRepository) {
        self.productQueryService = productQueryService
        self.discountRepository = discountRepository
        self.order = Order()
    }
    
    mutating func subscribeOrder(onPublishOrder: @escaping (OrderPendingDto) -> Void) {
        self.onPublishOrder = onPublishOrder
    }
    
    func getProducts() -> Array<ProductCategoryDto> {
        return productQueryService.fetchProducts()
    }
    
    func getDiscounts() -> Array<DiscountDto> {
        return discountRepository.findAll()
            .map({ discount in
                DiscountDto(name: discount.name, id: discount.id, discountType: discount.discountType, discountPrice: discount.discountPrice)
            })
    }
    
    func getOrder() -> OrderPendingDto {
        return OrderPendingDto(
            id: self.order.id,
            cart: CartDto(
                items: self.order.cart.getItems().map({x in CartItemDto(
                    productId: x.productId,
                    productName: x.productName,
                    productAmount: x.productPrice,
                    quantity: x.getQuantity(),
                    totalAmount: x.totalPrice,
                    coffeeHowToBrew: x.coffeeHowToBrew != nil ? CoffeeHowToBrewDto(name: x.coffeeHowToBrew!.name, id: x.coffeeHowToBrew!.id, price: x.coffeeHowToBrew!.price, beanQuantityGrams: x.coffeeHowToBrew!.beanQuantityGrams) : nil
                )}),
                totalQuantity: self.order.cart.totalQuantity
            ),
            discounts: self.order.discounts.map({x in DiscountDto(name: x.name, id: x.id, discountType: x.discountType, discountPrice: x.discountPrice)}),
            totalAmount: self.order.totalAmount
        )
    }
    
    mutating func addItemToCart(product: ProductDto, productCategory: ProductCategoryDto, quantity: UInt32) {
        return self.addItemToCart(product: product, productCategory: productCategory, quantity: quantity, brew: nil)
    }
    
    mutating func addItemToCart(product: ProductDto, productCategory: ProductCategoryDto, quantity: UInt32, brew: CoffeeHowToBrewDto?) {
        if(product.productType == ProductType.coffee) {
            self.order.cart.addItem(newItem: try! CartItem(
                coffee: CoffeeProduct(
                    productName: product.productName,
                    productId: product.productId,
                    productCategory: ProductCategory(name: productCategory.name, id: productCategory.id),
                    coffeeBean: CoffeeBean(id: product.coffeeBean!.id, name: product.coffeeBean!.name, gramQuantity: product.coffeeBean!.gramQuantity),
                    coffeeHowToBrews: product.coffeeHowToBrews!.map({brew in CoffeeHowToBrew(name: brew.name, id: brew.id, beanQuantityGrams: brew.beanQuantityGrams, price: brew.price)}),
                    isNowSales: product.isNowSales
                ),
                brew: CoffeeHowToBrew(name: brew!.name, id: brew!.id, beanQuantityGrams: brew!.beanQuantityGrams, price: brew!.price),
                quantity: quantity
            ))
        } else {
            self.order.cart.addItem(newItem: CartItem(
                product: OtherProduct(productName: product.productName, productId: product.productId, productCategory: ProductCategory(name: productCategory.name, id: productCategory.id),price: product.amount, stock: Stock(name: product.stock!.name, id: product.stock!.id, quantity: product.stock!.quantity), isNowSales: product.isNowSales),
                quantity: quantity)
            )
        }
    }
    
    mutating func increaseItemQuantity(itemIndex: Int) {
        let newQuantity = self.order.cart.getItems()[itemIndex].getQuantity() + 1
        self.order.cart.setItemQuantity(itemIndex: itemIndex, newQuantity: newQuantity)
    }
    
    mutating func decreaseItemQuantity(itemIndex: Int) {
        let cartItem = self.order.cart.getItems()[itemIndex]
        let quantity = cartItem.getQuantity()
        if(quantity == 1) {
            self.order.cart.removeItem(removeItem: cartItem)
            return
        }
        self.order.cart.setItemQuantity(itemIndex: itemIndex, newQuantity: quantity - 1)
    }
    
    mutating func removeItem(removeItem: CartItemDto) {
        self.order.cart.removeItem(removeItemProductId: removeItem.productId, removeItemBrewId: removeItem.coffeeHowToBrew?.id)
    }
    
    mutating func removeAllItem() {
        self.order.cart.removeAllItem()
    }
}
