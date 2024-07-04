//
//  SwiftUIView.swift
//  
//  
//  Created by　KaguraGateway on 2024/07/01
//  
//

import SwiftUI
import ComposableArchitecture
import LogoREGICore

public struct AppView: View {
    @Bindable var store: StoreOf<AppReducer>
    
    public init(store: StoreOf<AppReducer>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ContainerWithNavBar {
                Text("Hello World")
                NavigationLink("Go to Printer", state: AppReducer.Path.State.printerTest(PrinterTestFeature.State()))
                NavigationLink("Go to Payment", state: AppReducer.Path.State.payment(PaymentFeature.State(
                    newOrder: Order(cart: Cart(items: [
                        CartItem(
                            product: OtherProduct(
                                productName: "レモネード",
                                productId: "",
                                productCategory: ProductCategory(id: "", name: "", createdAt: Date(), updatedAt: Date(), syncAt: nil),
                                price: 500,
                                stock: Stock(name: "", id: "", quantity: 10, createdAt: Date(), updatedAt: Date(), syncAt: nil),
                                isNowSales: true,
                                createdAt: Date(),
                                updatedAt: Date(),
                                syncAt: nil
                            ),
                            quantity: 5
                        )
                    ]), discounts: [])
                )))
            }
                .navigationTitle("App")
        } destination: { store in
            switch store.case {
            case let .payment(store):
                PaymentView(store: store)
            case let .printerTest(store):
                PrinterTestView(store: store)
            }
        }
        .environment(\.isServerConnected, store.isServerConnected)
    }
}
