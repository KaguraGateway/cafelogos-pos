import Foundation
import ComposableArchitecture
import LogoREGICore

@Reducer
public struct ChooseCoffeeBrewSheetFeature {
    @ObservableState
    public struct State: Equatable {
        let selectProduct: ProductDto
        var chooseOptionSheetState: ChooseOptionSheetFeature.State;
        
        public init(selectProduct: ProductDto) {
            self.selectProduct = selectProduct
            
            self.chooseOptionSheetState = ChooseOptionSheetFeature.State(
                optionName: "ドリップ方法",
                options: selectProduct.coffeeHowToBrews?.map {
                    ChooseOption(id: $0.id, title: $0.name, description: "¥\($0.amount)")
                } ?? [ChooseOption]()
            )
        }
    }
    
    public enum Action {
        case chooseOptionSheetAction(ChooseOptionSheetFeature.Action)
        case delegate(Delegate)
        
        public enum Delegate {
            case onTapCoffeeBrew(ProductDto, CoffeeHowToBrewDto)
        }
    }
    
    public var body: some Reducer<State, Action> {
        Scope(state: \.chooseOptionSheetState, action: \.chooseOptionSheetAction) {
            ChooseOptionSheetFeature()
        }
        Reduce<State, Action> { state, action in
            switch action {
            case let .chooseOptionSheetAction(.delegate(.onAction(option))):
                let brewIndex = state.selectProduct.coffeeHowToBrews!.firstIndex(where: {
                    $0.id == option.id
                })
                return .send(.delegate(.onTapCoffeeBrew(
                    state.selectProduct,
                    state.selectProduct.coffeeHowToBrews![brewIndex!]
                )))
            case .chooseOptionSheetAction:
                return .none
            case .delegate:
                return .none
            }
        }
    }
}
