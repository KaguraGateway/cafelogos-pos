import Foundation
import ComposableArchitecture
import LogoREGICore

@Reducer
struct OrderEntryFeature {
    @ObservableState
    struct State {
        var categoriesWithProduct: [ProductCategoryWithProductsDto] = []
        var discounts: [Discount] = []
        var order: Order = Order()
        var isLoading = false
        var error: Error?
    }
    
    enum Action {
        case onAppear
        case fetchAllData
        case allDataFetched(TaskResult<(categories: [ProductCategoryWithProductsDto], discounts: [Discount])>)
        case fetchProductCatalog
        case fetchProductCatalogResponse(TaskResult<[ProductCategoryWithProductsDto]>)
        case fetchDiscounts
        case fetchDiscountsResponse(TaskResult<[Discount]>)
        case addItem(ProductDto, CoffeeHowToBrewDto?)
        case onTapDecrease(Int)
        case onTapIncrease(Int)
        case onRemoveItem(CartItem)
        case onRemoveAllItem
        case onTapDiscount(Discount)
    }
    
    //    ToDo: DIを実装する
    //    @Dependency(\.productService) var productService
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchAllData)
                
            case .fetchAllData:
                state.isLoading = true
                state.error = nil
                return .run { send in
                    await send(.allDataFetched(TaskResult {
                        async let categories = GetCategoriesWithProduct().Execute()
                        async let discounts = GetDiscounts().Execute()
                        let (fetchedCategories, fetchedDiscounts) = try await (categories, discounts)
                        return (categories: fetchedCategories, discounts: fetchedDiscounts)
                    }))
                }
                
            case let .allDataFetched(.success((categories, discounts))):
                state.isLoading = false
                state.categoriesWithProduct = categories
                state.discounts = discounts
                return .none
                
            case let .allDataFetched(.failure(error)):
                state.isLoading = false
                state.error = error
                return .none
                
            case .fetchProductCatalog:
                state.isLoading = true
                return .run { send in
                    await send(
                        .fetchProductCatalogResponse(
                            TaskResult { try await GetCategoriesWithProduct().Execute() }
                        )
                    )
                }
                
            case let .fetchProductCatalogResponse(.success(categoriesWithProduct)):
                state.isLoading = false
                state.categoriesWithProduct = categoriesWithProduct
                return .none
                
            case let .fetchProductCatalogResponse(.failure(error)):
                state.isLoading = false
                state.error = error
                return .none
                
            case .fetchDiscounts:
                return .run { send in
                    await send(.fetchDiscountsResponse(
                        TaskResult { try await GetDiscounts().Execute() }
                    ))
                }
                
            case let .fetchDiscountsResponse(.success(discounts)):
                state.isLoading = false
                state.discounts = discounts
                return .none
                
            case let .fetchDiscountsResponse(.failure(error)):
                state.isLoading = false
                state.error = error
                return .none
                
            case let .addItem(productDto, brew):
                // 商品カテゴリの生成
                let productCategory = ProductCategory(
                    id: productDto.productCategory.id,
                    name: productDto.productCategory.name,
                    createdAt: productDto.productCategory.createdAt,
                    updatedAt: productDto.productCategory.updatedAt,
                    syncAt: Date()
                )
                
                if productDto.productType == .coffee {
                    // コーヒー商品の場合
                    guard let brew = brew, let coffeeBean = productDto.coffeeBean, let coffeeHowToBrews = productDto.coffeeHowToBrews else {
                        // 必要な情報が不足している場合のエラーハンドリング
                        return .none
                    }
                    
                    // コーヒー商品の生成
                    let coffeeProduct = CoffeeProduct(
                        productName: productDto.productName,
                        productId: productDto.productId,
                        productCategory: productCategory,
                        coffeeBean: CoffeeBean(
                            id: coffeeBean.id,
                            name: coffeeBean.name,
                            gramQuantity: coffeeBean.gramQuantity,
                            createdAt: coffeeBean.createdAt,
                            updatedAt: coffeeBean.updatedAt,
                            syncAt: Date()
                        ),
                        coffeeHowToBrews: coffeeHowToBrews.map {
                            // 各淹れ方の変換
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
                        syncAt: Date()
                    )
                    
                    // 選択された淹れ方の生成
                    let brewItem = CoffeeHowToBrew(
                        name: brew.name,
                        id: brew.id,
                        beanQuantityGrams: brew.beanQuantityGrams,
                        amount: brew.amount,
                        createdAt: brew.createdAt,
                        updatedAt: brew.updatedAt,
                        syncAt: Date()
                    )
                    
                    do {
                        // カートアイテムの生成と追加
                        let newItem = try CartItem(coffee: coffeeProduct, brew: brewItem, quantity: 1)
                        state.order.cart.addItem(newItem: newItem)
                    } catch {
                        // カートアイテム生成時のエラーハンドリング
                        return .none
                    }
                } else {
                    // コーヒー以外の商品の場合
                    guard let stock = productDto.stock else {
                        // 在庫情報が不足している場合のエラーハンドリング
                        return .none
                    }
                    
                    // その他の商品の生成
                    let otherProduct = OtherProduct(
                        productName: productDto.productName,
                        productId: productDto.productId,
                        productCategory: productCategory,
                        price: productDto.amount,
                        stock: Stock(
                            name: stock.name,
                            id: stock.id,
                            quantity: stock.quantity,
                            createdAt: stock.createdAt,
                            updatedAt: stock.updatedAt,
                            syncAt: Date()
                        ),
                        isNowSales: productDto.isNowSales,
                        createdAt: productDto.createdAt,
                        updatedAt: productDto.updatedAt,
                        syncAt: Date()
                    )
                    
                    // カートアイテムの生成と追加
                    let newItem = CartItem(product: otherProduct, quantity: 1)
                    state.order.cart.addItem(newItem: newItem)
                }
                
                // アクション処理の完了
                return .none
                
            case let .onTapDecrease(index):
                if index < state.order.cart.items.count {
                    let currentQuantity = state.order.cart.items[index].getQuantity()
                    if currentQuantity > 1 {
                        state.order.cart.setItemQuantity(itemIndex: index, newQuantity: currentQuantity - 1)
                    } else {
                        // 数量が1の場合はアイテムを削除
                        let itemToRemove = state.order.cart.items[index]
                        state.order.cart.removeItem(removeItem: itemToRemove)
                    }
                }
                return .none
                
            case let .onTapIncrease(index):
                if index < state.order.cart.items.count {
                    let currentQuantity = state.order.cart.items[index].getQuantity()
                    state.order.cart.setItemQuantity(itemIndex: index, newQuantity: currentQuantity + 1)
                }
                return .none
                
            case let .onRemoveItem(cartItem):
                state.order.cart.removeItem(removeItem: cartItem)
                return .none
                
            case .onRemoveAllItem:
                state.order.cart.removeAllItem()
                return .none
                
            case let .onTapDiscount(discount):
                state.order.discounts.append(discount)
                return .none
            }
        }
    }
}
