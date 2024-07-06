import SwiftUI
import ComposableArchitecture

struct ChooseCoffeeBrewSheetView: View {
    var store: StoreOf<ChooseCoffeeBrewSheetFeature>
    
    var body: some View {
        ChooseOptionSheetView(
            store: store.scope(state: \.chooseOptionSheetState, action: \.chooseOptionSheetAction)
        )
    }
}
