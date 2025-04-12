import SwiftUI
import ComposableArchitecture
import LogoREGICore

@Reducer
public struct UIKitTestFeature {
    @ObservableState
    public struct State: Equatable {
        var title: String = "UIKit統合テスト"
        
        public init() {}
    }
    
    public enum Action {
        case updateTitle(String)
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .updateTitle(newTitle):
                state.title = newTitle
                return .none
            }
        }
    }
}
