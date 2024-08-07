// 金額入力画面

import SwiftUI
import ComposableArchitecture

// 複数金種の入力フォーム
struct DenominationFormList: View {
    let store: StoreOf<DenominationFormListFeature>
    
    var body: some View {
        VStack(spacing: 0){
            
            Form {
                Section(header:
                            Text("釣り銭入力")
                    .font(.title)
                    .fontWeight(.semibold)
                ){
                    ForEach(store.denominations.denominations.indices, id: \.self) { index in
                        DenominationForm(
                            denomination: store.denominations.denominations[index],
                            onUpdate: { newValue in
                                store.send(.updateDenomination(index: index, newValue: newValue))
                            }
                        )
                    }
                }
            }
            Divider()
            HStack(){
                Text("合計")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Spacer()
                Text("¥\(store.denominations.total())")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
            }
            
            .padding(.horizontal, 100)
            .padding(.vertical, 10)
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
