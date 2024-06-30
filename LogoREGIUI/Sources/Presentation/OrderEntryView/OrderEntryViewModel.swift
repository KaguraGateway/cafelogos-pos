//
//  OrderEntryViewModel.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/11.
//

import Foundation
import StarIO10
import LogoREGICore

class OrderEntryViewModel: ObservableObject, StarDeviceDiscoveryManagerDelegate {
    @Published public var printer: StarPrinter? = nil
    @Published public var categoriesWithProduct = [ProductCategoryWithProductsDto]()
    @Published public var discounts = [Discount]()
    @Published public var order = Order()
    
    init() {
        if self.printer == nil {
            self.discovery()
        }
    }
    
    @MainActor
    func fetch() async {
        categoriesWithProduct = await GetCategoriesWithProduct().Execute()
        discounts = await GetDiscounts().Execute()
    }
    
    func onTapDiscount(discount: Discount) {
        order.discounts.append(discount)
    }
    
    func onTapIncrease(index: Int) {
        self.order.cart.setItemQuantity(itemIndex: index, newQuantity: self.order.cart.items[index].getQuantity() + 1)
    }
    
    func onTapDecrease(index: Int) {
        let currentQuantity = self.order.cart.items[index].getQuantity()
        if currentQuantity == 0 {
            return
        }
        self.order.cart.setItemQuantity(itemIndex: index, newQuantity: currentQuantity - 1)
    }
    
    func onRemoveItem(cartItem: CartItem) {
        self.order.cart.removeItem(removeItem: cartItem)
    }
    
    func onRemoveAllItem() {
        self.order.cart.removeAllItem()
    }
    
    func addItem(productDto: ProductDto) {
        self.addItem(productDto: productDto, brew: nil)
    }
    
    func addItem(productDto: ProductDto, brew: CoffeeHowToBrewDto?) {
        let productCategory = ProductCategory(
            id: productDto.productCategory.id,
            name: productDto.productCategory.name,
            createdAt: productDto.productCategory.createdAt,
            updatedAt: productDto.productCategory.updatedAt,
            syncAt: Date())
        if(productDto.productType == ProductType.coffee) {
            self.order.cart.addItem(newItem: try! CartItem(
                coffee: CoffeeProduct(
                    productName: productDto.productName,
                    productId: productDto.productId,
                    productCategory: productCategory,
                    coffeeBean: CoffeeBean(
                        id: productDto.coffeeBean!.id,
                        name: productDto.coffeeBean!.name,
                        gramQuantity: productDto.coffeeBean!.gramQuantity,
                        createdAt: productDto.coffeeBean!.createdAt,
                        updatedAt: productDto.coffeeBean!.updatedAt,
                        syncAt: Date()
                    ),
                    coffeeHowToBrews: productDto.coffeeHowToBrews!.map {
                        CoffeeHowToBrew(
                            name: $0.name,
                            id: $0.id,
                            beanQuantityGrams: $0.beanQuantityGrams,
                            amount: $0.amount,
                            createdAt: $0.createdAt,
                            updatedAt: $0.updatedAt,
                            syncAt: Date()
                        )
                    },
                    isNowSales: productDto.isNowSales,
                    createdAt: productDto.createdAt,
                    updatedAt: productDto.updatedAt,
                    syncAt: Date()),
                brew: CoffeeHowToBrew(
                    name: brew!.name,
                    id: brew!.id,
                    beanQuantityGrams: brew!.beanQuantityGrams,
                    amount: brew!.amount,
                    createdAt: brew!.createdAt,
                    updatedAt: brew!.updatedAt,
                    syncAt: Date()
                ),
                quantity: 1)
            )
        } else {
            self.order.cart.addItem(newItem: CartItem(
                product: OtherProduct(
                    productName: productDto.productName,
                    productId: productDto.productId,
                    productCategory: productCategory,
                    price: productDto.amount,
                    stock: Stock(
                        name: productDto.stock!.name,
                        id: productDto.stock!.id,
                        quantity: productDto.stock!.quantity,
                        createdAt: productDto.stock!.createdAt,
                        updatedAt: productDto.stock!.updatedAt,
                        syncAt: Date()
                    ),
                    isNowSales: productDto.isNowSales,
                    createdAt: productDto.createdAt,
                    updatedAt: productDto.updatedAt,
                    syncAt: Date()
                ),
                quantity: 1)
            )
        }
    }
    
    
    
    func manager(_ manager: StarDeviceDiscoveryManager, didFind printer: StarPrinter) {
         DispatchQueue.main.async {
             manager.stopDiscovery()
             self.printer = printer
         }
     }
     
     func managerDidFinishDiscovery(_ manager: StarIO10.StarDeviceDiscoveryManager) {
         DispatchQueue.main.async {
             print("did finish")
         }
     }
     
     func discovery(){
         if let manager = try? StarDeviceDiscoveryManagerFactory.create(interfaceTypes: [.bluetooth]){
             manager.delegate = self
             manager.discoveryTime = 1000
             do{
                 try manager.startDiscovery()
             }
             catch{
                 print("error")
             }
         }
     }
}
