import Foundation
import ComposableArchitecture
import LogoREGICore

@Reducer
public struct ChooseOrderSheetFeature {
    @ObservableState
    public struct State: Equatable {
        var selectSeatType = 0
        var seats: [Seat] = []
        
        let orders: [Order]
        
        public init(orders: [Order]) {
            self.orders = orders
        }
    }
    
    public enum Action {
        case changeSelectSeatType(Int)
        case fetchSeats
        case fetchedSeats(Result<[Seat], Error>)
        case delegate(Delegate)
        
        public enum Delegate {
            case getUnpaidOrdersById(String)
            case close
        }
    }
    
    public var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case let .changeSelectSeatType(newSelect):
                state.selectSeatType = newSelect
                return .none
            case .fetchSeats:
                return .run { send in
                    await send(.fetchedSeats(Result {
                        await GetSeats().Execute()
                    }))
                }
            case let .fetchedSeats(.success(seats)):
                state.seats = seats
                return .none
            case .fetchedSeats(.failure):
                return .none
            case .delegate:
                return .none
            }
        }
    }
}
