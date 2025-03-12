import Foundation
import ComposableArchitecture
import LogoREGICore

@Reducer
public struct OrderEntryFeature {
    @ObservableState
    public struct State: Equatable {
        var discounts: [Discount]
        var order: Order
        
        var productStackState: ProductStackFeature.State
        var orderBottomBarState: OrderBottomBarFeature.State
        @Presents var alert: AlertState<Action.Alert>?
        
        var isLoading: Bool = false
        
        public init() {
            let order = Order()
            self.order = order
            self.discounts = []
            self.productStackState = ProductStackFeature.State()
            orderBottomBarState = OrderBottomBarFeature.State(orders: [])
            self.alert = nil
        }
    }
    
    public enum Action {
        case onAppear
        case fetchAllData
        case allDataFetched(TaskResult<(categories: [ProductCatalogDto], discounts: [Discount])>)
        case fetchDiscounts
        case fetchDiscountsResponse(TaskResult<[Discount]>)
        case addItem(ProductDto, CoffeeHowToBrewDto?)
        case onTapDecrease(Int)
        case onTapIncrease(Int)
        case onRemoveItem(CartItem)
        case onTapDiscount(Discount)
        
        case productStackAction(ProductStackFeature.Action)
        case orderBottomBarAction(OrderBottomBarFeature.Action)
        
        case navigatePaymentWithOrders([Order])
        
        case fetchedUnPaidOrders(Result<[Order], Error>)
        
        case productConnectionError(Int)
        
        // サーバー接続状態
        case setIsServerConnected(Bool)
        
        // Navigation
        case popToRoot
        
        // Alert
        case alert(PresentationAction<Action.Alert>)
        
        @CasePathable
        public enum Alert {
            case okTapped
        }
    }
    
    //    ToDo: エラーハンドリングをちゃんと実装する
    //    頑張りましたが、コンパイラがやる気を無くしたので見送り
    //    https://github.com/KaguraGateway/cafelogos-pos/pull/43#issuecomment-2204918216
    
    public var body: some Reducer<State, Action> {
        Scope(state: \.productStackState, action: \.productStackAction) {
            ProductStackFeature()
        }
        Scope(state: \.orderBottomBarState, action: \.orderBottomBarAction) {
            OrderBottomBarFeature()
        }
        
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                // ホームから遷移するときに初期化したいが、dismissで戻る時は初期化したくないので、cartItemが空のときのみ初期化
                if state.order.cart.items.isEmpty {
                    state.order = Order()
                }
                return .none
                
            case .productStackAction(.fetch):
                state.isLoading = true
                return .none
                
            case .productStackAction(.fetched(.success(_))):
                state.isLoading = false
                return .none
                
            case .fetchAllData:
//                return .run { send in
//                    await send(.allDataFetched(TaskResult {
//                        // 本番環境
////                        async let categories = GetCategoriesWithProduct().Execute()
////                        async let discounts = GetDiscounts().Execute()
//
//                        // モック利用
//                        async let categories = ProductQueryServiceMock().fetchProductCategoriesWithProducts()
//                        async let discounts = DiscountRepositoryMock().findAll()
//
//                        // return処理周り
//                        let (fetchedCategories, fetchedDiscounts) = try await (categories, discounts)
//                        return (categories: fetchedCategories, discounts: fetchedDiscounts)
//                    }))
//                }
                return .none
                
            case .fetchDiscounts:
                return .run { send in
                    await send(.fetchDiscountsResponse(
                        TaskResult { await GetDiscounts().Execute() }
                    ))
                }
                
            case let .fetchDiscountsResponse(.success(discounts)):
                state.discounts = discounts
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
                // TODO: 設計ミスったからゴリ押した、直す
                state.orderBottomBarState = OrderBottomBarFeature.State(newOrder: state.order)
                return .none
                
            case let .onTapIncrease(index):
                if index < state.order.cart.items.count {
                    let currentQuantity = state.order.cart.items[index].getQuantity()
                    state.order.cart.setItemQuantity(itemIndex: index, newQuantity: currentQuantity + 1)
                    // TODO: 設計ミスったからゴリ押した、直す
                    state.orderBottomBarState = OrderBottomBarFeature.State(newOrder: state.order)
                }
                return .none
                
            case let .onRemoveItem(cartItem):
                state.order.cart.removeItem(removeItem: cartItem)
                // TODO: 設計ミスったからゴリ押した、直す
                state.orderBottomBarState = OrderBottomBarFeature.State(newOrder: state.order)
                return .none
                
            case let .onTapDiscount(discount):
                state.order.discounts.append(discount)
                // TODO: 設計ミスったからゴリ押した、直す
                state.orderBottomBarState = OrderBottomBarFeature.State(newOrder: state.order)
                return .none
                
            case .orderBottomBarAction(.delegate(.removeAllItem)):
                state.order.cart.removeAllItem()
                // TODO: 設計ミスったからゴリ押した、直す
                state.orderBottomBarState = OrderBottomBarFeature.State(newOrder: state.order)
                return .none
                
            case .productStackAction(.delegate(.onConnectionError(_))):
                // サーバー接続エラーの処理
                state.isLoading = false
                state.alert = AlertState {
                    TextState("接続エラー")
                } actions: {
                    ButtonState(action: .okTapped) {
                        TextState("OK")
                    }
                } message: {
                    TextState("サーバーに接続できませんでした。インターネットに接続されていますか？もしくは、設定 ＞ ホストURLが正しいか確認してください。")
                }
                return .send(.productConnectionError(-1))
                
            case let .productStackAction(.delegate(.onServerConnectionChanged(isConnected))):
                // サーバー接続状態を更新
                return .send(.setIsServerConnected(isConnected))
                
            case let .productStackAction(.delegate(.onAddItem(productDto, brew))):
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
                // TODO: 設計ミスったからゴリ押した、直す
                state.orderBottomBarState = OrderBottomBarFeature.State(newOrder: state.order)
                return .none
            case let .orderBottomBarAction(.destination(.presented(.chooseOrderSheet(.delegate(.getUnpaidOrdersById(seatId)))))):
                return .run { send in
                    await send(
                        .fetchedUnPaidOrders(Result {
                            await GetUnpaidOrdersById().Execute(seatId: seatId)
                        })
                    )
                }
            case let .fetchedUnPaidOrders(.success(orders)):
                if orders.isEmpty {
                    state.alert = AlertState {
                        TextState("伝票呼出エラー")
                    } actions: {
                        ButtonState(action: .okTapped) {
                            TextState("OK")
                        }
                    } message: {
                        TextState("この伝票には注文が登録されていません")
                    }
                    return .none
                }
                return .send(.navigatePaymentWithOrders(orders))
            
            case .alert(.presented(let alertAction)):
                switch alertAction {
                case .okTapped:
                    state.alert = nil
                    // 前のページに戻る
                    return .send(.popToRoot)
                }

            // アラートの処理を追加する場合はこれより上に書く
            case .alert:
                return .none
                
            case .productConnectionError(_):
                // サーバー接続エラーを親コンポーネントに通知
                return .send(.setIsServerConnected(false))

            default:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
