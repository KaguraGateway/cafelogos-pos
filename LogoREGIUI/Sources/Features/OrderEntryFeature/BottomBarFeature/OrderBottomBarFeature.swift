import Foundation
import LogoREGICore
import ComposableArchitecture

@Reducer
public struct OrderBottomBarFeature {
    @Reducer(state: .equatable)
    public enum Destination {
        case chooseOrderSheet(ChooseOrderSheetFeature)
    }
    
    @ObservableState
    public struct State: Equatable {
        let orders: [Order]
        var newOrder: Order?
        
        @Presents var destination: Destination.State?
        
        // 新規注文
        public init(newOrder: Order) {
            self.init(orders: [newOrder])
            self.newOrder = newOrder
        }
        
        // 伝票呼び出しで注文を呼び出した場合
        public init(orders: [Order]) {
            self.orders = orders
        }
    }
    
    public enum Action {
        case destination(PresentationAction<Destination.Action>)
        case openChooseOrderSheet
        case delegate(Delegate)
        
        public enum Delegate {
            case removeAllItem
            case removeOrders
        }
    }
    
    public var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .openChooseOrderSheet:
                state.destination = .chooseOrderSheet(ChooseOrderSheetFeature.State(orders: state.orders))
                return .none
            case .destination:
                return .none
            case .delegate:
                return .none
            }
        }
    }
}
