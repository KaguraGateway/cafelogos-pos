// タイトルと金額を表示するコンポーネント
import SwiftUI

struct TitledAmountView:View {
    var title: String
    var amount: Int
    
    init(title: String, amount: Int) {
        self.title = title
        self.amount = amount
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text(title)
                .font(.title)
                .foregroundColor(.primary)
            Text("¥\(amount)")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.top, 10)
                .foregroundColor(amount < 0 ? .red : .primary)
        }
    }
}
