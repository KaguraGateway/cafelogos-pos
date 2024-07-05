import SwiftUI
import ComposableArchitecture
import LogoREGICore

@Reducer
public struct PrinterTestFeature {
    @ObservableState
    public struct State: Equatable {
    }
    
    public enum Action {
        case print
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .print:
                Task {
                    await CashierTest().Execute()
                }
                return .none
            }
        }
    }
    
}
