// 金額入力画面

import SwiftUI
import LogoREGICore

// 複数金種の入力フォーム
struct DenominationFormList: View {
    @Binding var denominations: Denominations
    
    var body: some View {
        VStack(spacing: 0){
            
            Form {
                Section(header:
                            Text("釣り銭入力")
                    .font(.title)
                    .fontWeight(.semibold)
                ){
                    ForEach(denominations.denominations.indices, id: \.self) { index in
                        DenominationForm(denomination: self.$denominations.denominations[index])
                    }
                }
            }
            Divider()
            HStack(){
                Text("合計")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Spacer()
                Text("¥\(denominations.total())")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
            }
            
            .padding(.horizontal, 100)
            .padding(.vertical, 10)
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
