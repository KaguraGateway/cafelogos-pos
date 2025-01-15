import SwiftUI
import ComposableArchitecture

struct ChooseOptionSheetView: View {
    var store: StoreOf<ChooseOptionSheetFeature>
    
    var body: some View {
        NavigationStack() {
            ScrollView{
                LazyVGrid(columns: [
                    GridItem(.flexible(),spacing: 20),
                        GridItem(.flexible(),spacing: 20),
                        GridItem(.flexible(),spacing: 20),
                ], spacing: 20) {
                    ForEach(store.options, id: \.id) { option in
                        Button(action: {
                            store.send(.onTapOption(option))
                        }){
                            VStack(spacing: 0) {
                                // OptionTitle
                                Text(option.title)
                                    .font(.system(.largeTitle, weight: .semibold))
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                                // OptionDescription
                                Text(option.description)
                                    .padding(.top, 10)
                                    .font(.title3)
                                    .lineLimit(3)
                            }
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity, minHeight: 130, alignment: .center)
                            .padding(20)
                            .background {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color(.systemFill))
                            }
                        }
                    }
                }
                .padding(20)
                .padding(.top)
            }
            .navigationTitle(store.optionName + "のオプションを選択")
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 10) {
                        Button("注文入力に戻る") {
                            store.send(.delegate(.close))
                        }
                    }
                }
            }
        }
    }
}
