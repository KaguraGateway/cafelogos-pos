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

            case let .addItem(product, howToBrew):
                // アイテム追加ロジックをここに追加
                return .none
                
            case let .onTapDecrease(index):
                // 数量減少ロジックをここに追加
                return .none
                
            case let .onTapIncrease(index):
                if index < state.order.cart.items.count {
                    let currentQuantity = state.order.cart.items[index].getQuantity()
                    state.order.cart.setItemQuantity(itemIndex: index, newQuantity: currentQuantity + 1)
                }
                return .none
                
            case let .onRemoveItem(cartItem):
                // アイテム削除ロジックをここに追加
                return .none
                
            case .onRemoveAllItem:
                // 全アイテム削除ロジックをここに追加
                return .none
                
            case let .onTapDiscount(discount):
                state.order.discounts.append(discount)
                return .none
            }
        }
    }
}
