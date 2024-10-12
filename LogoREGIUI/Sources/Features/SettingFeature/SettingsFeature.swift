// 設定画面のFeature

import Foundation
import ComposableArchitecture
import LogoREGICore

@Reducer
public struct SettingsFeature {
    @ObservableState
    public struct State: Equatable {
    }
    
    public enum Action {
        case onApper
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onApper:
                return .none
            }
        }
    }
}
