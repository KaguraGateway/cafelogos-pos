import Foundation
import ComposableArchitecture
import LogoREGICore

@Reducer
struct DiscountFeature {
    @ObservableState
    struct State {
        var discounts: [Discount] = []
        var appliedDiscounts: [Discount] = []
        
    }
    
    enum Action {
        case applyDiscount(Discount)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .applyDiscount(discount):
                state.appliedDiscounts.append(discount)
                return .none
            }
        }
    }
    
}
