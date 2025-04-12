import Foundation
import ComposableArchitecture
import LogoREGICore

@Reducer
public struct OrdersListFeature {
    @ObservableState
    public struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        var adminUrl: String = ""
        var config: Config
        
        public init() {
            self.config = GetConfig().Execute()
            self.adminUrl = config.adminUrl
        }
    }
    
    public enum Action {
        case onAppear
        case showAlert
        case alert(PresentationAction<Alert>)
        case popToRoot
        
        @CasePathable
        public enum Alert {
            case okTapped
        }
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.adminUrl.isEmpty {
                    return .send(.showAlert)
                }
                return .none
                
            case .showAlert:
                state.alert = AlertState {
                    TextState("管理画面URLが設定されていません")
                } actions: {
                    ButtonState(action: .okTapped) {
                        TextState("OK")
                    }
                } message: {
                    TextState("設定画面 > 管理画面URLを設定してください")
                }
                return .none
                
            case .alert(.presented(.okTapped)):
                state.alert = nil
                return .send(.popToRoot)
                
            case .alert(.dismiss):
                state.alert = nil
                return .send(.popToRoot)
                
            case .popToRoot:
                return .none
            }
        }
    }
}
