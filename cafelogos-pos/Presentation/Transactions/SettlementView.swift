//
//  SettlementView.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/09/22.
//

import SwiftUI

// サンプルデータ
struct ChargenData {
    var denomination: Int
    var quantity: Int
    var amount: Int
}
struct SettlementView: View {
    @State private var displayConnection: Bool = true // true: 接続中, false: 切断中
    @State private var serverConnection: Bool = true // true: 接続中, false: 切断中
    @State private var isTraining: Bool = false
    
    @ObservedObject var viewModel = SettlementViewModel()
    
    
    var body: some View {
        NavBarBody(displayConnection: $displayConnection, serverConnection: $serverConnection, title: "精算"){
            GeometryReader {geometry in
                HStack(spacing:0){
                    ChargeInputView(denominations: $viewModel.current)
                    Divider()
                    VStack(alignment: .leading){
                        ChargeInfo(title: "あるべき釣り銭(A)", amount: viewModel.shouldTotal())
                            .padding(.bottom)
                            .padding(.top, 50)
                        ChargeInfo(title: "現在の釣り銭(B)", amount: viewModel.currentTotal())
                            .padding(.bottom)
                        ChargeInfo(title: "誤差(B-A)", amount: viewModel.diffAmount())
                        Spacer()
                        TitleButton(title: "精算完了", bgColor: Color.cyan, fgColor: Color.white, destination: {HomeView()})
                            .simultaneousGesture(TapGesture().onEnded {
                                viewModel.complete()
                            })
                    }
                    .padding(.horizontal)
                    .frame(width: geometry.size.width * 0.3)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

struct ChargeInfo:View {
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

struct ChargeInputView: View {
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

struct DenominationForm: View {
    @Binding var denomination: Denomination
    
    var body: some View {
        HStack(alignment: .center){
            HStack(){
                Text("")
                Spacer()
                Text("\(denomination.amount)円")
                
            }
            .frame(maxWidth: 100)
            
            
            Spacer()
            Text("×")
                .padding(.trailing)
            TextField("0", value: Binding(get: { denomination.quantity }, set: { denomination.setQuantity(newValue: $0) }), formatter: NumberFormatter())
                .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification), perform: { obj in
                    if let textField = obj.object as? UITextField {
                        textField.selectAll(textField.text)
                        
                    }
                })
                .multilineTextAlignment(.trailing)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 180)
            
            
            Text("=")
            HStack(){
                Spacer()
                Text("¥\(denomination.total())")
                
                
            }
            .frame(maxWidth: 100)
            .padding(.trailing)
        }
        .frame(maxWidth: .infinity)
        
        
        
        .padding(.vertical, 5)
        
        .font(.title3)
        
    }
}

struct SettlementView_Previews: PreviewProvider {
    static var previews: some View {
        SettlementView()
            .previewInterfaceOrientation(.landscapeRight)
        //            .previewDevice("iPad (9th generation)")
        //            .previewDevice("iPad mini (6th generation)")
            .previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}
