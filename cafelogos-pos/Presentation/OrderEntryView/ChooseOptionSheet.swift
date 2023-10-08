import SwiftUI

struct ChooseOptionSheet: View {
    @Environment(\.dismiss) var dismiss
    let ProductName: String
    // サンプルデータ
    let options: [Option] = [
        Option(id: 1, title: "ペーパー", description: "紙のフィルターを使ってコーヒーをドリップ"),
        Option(id: 2, title: "ネル", description: "布のフィルターを使ってコーヒーをドリップ"),
        Option(id: 3, title: "サイフォン", description: "サイフォンを使ってコーヒーをドリップ")
    ]
    
    var body: some View {
        NavigationStack() {
            ScrollView{
                LazyVGrid(columns: gridItems, spacing: 20) {
                    ForEach(options, id: \.id) { option in
                        Button(action: {
                            // いい感じに送信してくだされ
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
            .navigationTitle(ProductName + "のオプションを選択")
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
    let id: Int
    let title: String
    let description: String
}

struct ProductOptionsPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseOptionSheet(ProductName: "ドリップ")
            .previewInterfaceOrientation(.landscapeRight)
            .previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}
