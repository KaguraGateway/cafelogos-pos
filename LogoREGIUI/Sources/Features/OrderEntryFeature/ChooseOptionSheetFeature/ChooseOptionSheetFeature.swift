import SwiftUI
import Foundation
import ComposableArchitecture

@Reducer
public struct ChooseOptionSheetFeature {
    @ObservableState
    public struct State: Equatable {
        let optionName: String
        let options: [ChooseOption]
        
        public init(optionName: String, options: [ChooseOption]) {
            self.optionName = optionName
            self.options = options
        }
    }
    
    public enum Action {
        case onTapOption(ChooseOption)
        case delegate(Delegate)
        
        public enum Delegate {
            case onAction(ChooseOption)
            case close
        }
    }
    
    public var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case let .onTapOption(option):
                return .send(.delegate(.onAction(option)))
            case .delegate:
                return . none
            }
        }
    }
}

public struct ChooseOption: Identifiable, Equatable {
    public let id: String
    let title: String
    let description: String
}
