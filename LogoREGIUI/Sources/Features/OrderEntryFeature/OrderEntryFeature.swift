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
    }
    
    enum Action {
        case onAppear
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
                return .send(.fetchProductCatalog)
                
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
                // エラーハンドリングをここに追加
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
                
            case .fetchDiscountsResponse(.failure):
                state.isLoading = false
                // エラーハンドリングをここに追加
                return .none
                
            case let .addItem(product, howToBrew):
                // アイテム追加ロジックをここに追加
                return .none
                
            case let .onTapDecrease(index):
                // 数量減少ロジックをここに追加
                return .none
                
            case let .onTapIncrease(index):
                // 数量増加ロジックをここに追加
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
