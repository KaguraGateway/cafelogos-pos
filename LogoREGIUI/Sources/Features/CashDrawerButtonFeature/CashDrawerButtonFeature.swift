import SwiftUI
import ComposableArchitecture
import LogoREGICore

@Reducer
struct CashDrawerButtonFeature {
    @ObservableState
    public struct State: Equatable {
    }
    
    public enum Action {
        case openCashDrawer
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .openCashDrawer:
                return .run { _ in
                    await DrawerTest().Execute()
                }
            }
        }
    }
}
