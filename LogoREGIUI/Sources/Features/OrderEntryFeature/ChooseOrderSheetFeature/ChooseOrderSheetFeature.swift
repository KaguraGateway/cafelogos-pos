import Foundation
import ComposableArchitecture
import LogoREGICore

@Reducer
public struct ChooseOrderSheetFeature {
    @ObservableState
    public struct State: Equatable {
        var selectSeatType = 0
        
        let orders: [Order]
        let seats: [Seat] = []
        
        public init(orders: [Order]) {
            self.orders = orders
        }
    }
    
    public enum Action {
        case changeSelectSeatType(Int)
        case close
        case delegate(Delegate)
        
        public enum Delegate {
            case getUnpaidOrdersById(String)
        }
    }
    
    public var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case let .changeSelectSeatType(newSelect):
                state.selectSeatType = newSelect
                return .none
            case .delegate:
                return .none
            case .close:
                return .none
            }
        }
    }
}
