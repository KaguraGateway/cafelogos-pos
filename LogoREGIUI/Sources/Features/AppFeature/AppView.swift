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
                        ),
                        try! CartItem(
                            coffee: CoffeeProduct(
                                productName: "logos Honduras",
                                productId: "unique-product-id",
                                productCategory: ProductCategory(
                                    id: "unique-category-id",
                                    name: "Coffee",
                                    createdAt: Date(),
                                    updatedAt: Date(),
                                    syncAt: Date()
                                ),
                                coffeeBean: CoffeeBean(
                                    id: "unique-bean-id",
                                    name: "logos Honduras",
                                    gramQuantity: 100,
                                    createdAt: Date(),
                                    updatedAt: Date(),
                                    syncAt: Date()
                                ),
                                coffeeHowToBrews: [
                                    CoffeeHowToBrew(name: "ネル", id: "unique-brew-id-1", beanQuantityGrams: 100, amount: 400, createdAt: Date(), updatedAt: Date(), syncAt: Date()),
                                    CoffeeHowToBrew(name: "サイフォン", id: "unique-brew-id-2", beanQuantityGrams: 100, amount: 500, createdAt: Date(), updatedAt: Date(), syncAt: Date()),
                                    CoffeeHowToBrew(name: "ペーパー", id: "unique-brew-id-3", beanQuantityGrams: 100, amount: 700, createdAt: Date(), updatedAt: Date(), syncAt: Date()),
                                    CoffeeHowToBrew(name: "マキネッタ（アメリカーノ）", id: "unique-brew-id-4", beanQuantityGrams: 100, amount: 500, createdAt: Date(), updatedAt: Date(), syncAt: Date()),
                                    CoffeeHowToBrew(name: "マキネッタ（ロングブラック）", id: "unique-brew-id-5", beanQuantityGrams: 100, amount: 500, createdAt: Date(), updatedAt: Date(), syncAt: Date()),
                                    CoffeeHowToBrew(name: "マキネッタ（エスプレッソ）", id: "unique-brew-id-6", beanQuantityGrams: 100, amount: 500, createdAt: Date(), updatedAt: Date(), syncAt: Date()),
                                    CoffeeHowToBrew(name: "フレンチプレス", id: "unique-brew-id-7", beanQuantityGrams: 100, amount: 500, createdAt: Date(), updatedAt: Date(), syncAt: Date()),
                                    CoffeeHowToBrew(name: "コールドブリュー", id: "unique-brew-id-8", beanQuantityGrams: 100, amount: 500, createdAt: Date(), updatedAt: Date(), syncAt: Date()),
                                    CoffeeHowToBrew(name: "アイスブリュー", id: "unique-brew-id-9", beanQuantityGrams: 100, amount: 500, createdAt: Date(), updatedAt: Date(), syncAt: Date())
                                ],
                                isNowSales: true,
                                createdAt: Date(),
                                updatedAt: Date(),
                                syncAt: Date()
                            ),
                            brew: CoffeeHowToBrew(
                                name: "マキネッタ（ロングブラック）",
                                id: "unique-brew-id-5",
                                beanQuantityGrams: 100,
                                amount: 500,
                                createdAt: Date(),
                                updatedAt: Date(),
                                syncAt: Date()
                            ),
                            quantity: 10
                        ),
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
