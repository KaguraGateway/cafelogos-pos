
import Foundation
import ComposableArchitecture
import LogoREGICore

@Reducer
public struct PaymentListFeature {
    @ObservableState
    public struct State: Equatable {
        var payments: [Payment] = []
        var isLoading: Bool = false
        
        public init() {}
    }
    
    public enum Action {
        case onAppear
        case loadPayments
        case paymentsLoaded([Payment])
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.loadPayments)
                
            case .loadPayments:
                state.isLoading = true
                let payments = GetAllPayments().Execute()
                return .send(.paymentsLoaded(payments))
                
            case let .paymentsLoaded(payments):
                state.payments = payments
                state.isLoading = false
                return .none
            }
        }
    }
}
