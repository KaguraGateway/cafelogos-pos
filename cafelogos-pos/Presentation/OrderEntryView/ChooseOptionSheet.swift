import SwiftUI

struct ChooseOptionSheet: View {
    @Environment(\.dismiss) var dismiss
    public let productName: String
    public let options: [Option]
    public let onAction: (Option) -> Void
    
    public init(productName: String, options: [Option], onAction: @escaping (Option) -> Void) {
        self.productName = productName
        self.options = options
        self.onAction = onAction
    }
    
    var body: some View {
        NavigationStack() {
            ScrollView{
                LazyVGrid(columns: gridItems, spacing: 20) {
                    ForEach(options, id: \.id) { option in
                        Button(action: {
                            onAction(option)
                            dismiss()
                        }){
                            VStack(spacing: 0) {
                                // OptionTitle
                                Text(option.title)
                                    .font(.system(.largeTitle, weight: .semibold))
                                    .lineLimit(0)
                                // OptionDescription
                                Text(option.description)
                                    .padding(.top, 10)
                                    .font(.title3)
                                    .lineLimit(3)
                            }
                            .foregroundColor(.primary)
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
            .navigationTitle(productName + "のオプションを選択")
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 10) {
                        Button("注文入力に戻る") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}


// サンプル構造体
struct Option: Identifiable {
    let id: String
    let title: String
    let description: String
}

struct ProductOptionsPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseOptionSheet(productName: "ドリップ", options: [
            Option(id: "a", title: "ペーパー", description: "紙のフィルターを使ってコーヒーをドリップ"),
            Option(id: "b", title: "ネル", description: "布のフィルターを使ってコーヒーをドリップ"),
            Option(id: "c", title: "サイフォン", description: "サイフォンを使ってコーヒーをドリップ")
        ], onAction: {_ in 
            
        })
            .previewInterfaceOrientation(.landscapeRight)
            .previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}
