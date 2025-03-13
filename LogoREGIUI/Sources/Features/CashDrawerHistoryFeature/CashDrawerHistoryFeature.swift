// レジ操作履歴を管理するFeature

import Foundation
import ComposableArchitecture
import LogoREGICore

@Reducer
public struct CashDrawerHistoryFeature {
    @ObservableState
    public struct State: Equatable {
        var denominations: [Denomination] = []
        var isLoading: Bool = false
        
        @Presents var alert: AlertState<Action.Alert>?
        
        public init() {}
    }
    
    public enum Action {
        case onAppear
        case loadDenominations
        case denominationsLoaded([Denomination])
        case popToRoot
        
        // Alert
        case alert(PresentationAction<Action.Alert>)
        
        @CasePathable
        public enum Alert {
            case okTapped
            case cancel
        }
    }
    
    public init() {}
    
    @Dependency(\.denominationRepository) private var denominationRepo
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.loadDenominations)
                
            case .loadDenominations:
                state.isLoading = true
                return .run { send in
                    let denominations = await GetDenominations().Execute()
                    await send(.denominationsLoaded(denominations.denominations))
                }
                
            case let .denominationsLoaded(denominations):
                state.denominations = denominations
                state.isLoading = false
                return .none
                
            case .popToRoot:
                return .none
                
            case .alert(.presented(let alertAction)):
                state.alert = nil
                switch alertAction {
                case .okTapped:
                    return .none
                case .cancel:
                    return .none
                }
                
            case .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
