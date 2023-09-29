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
    
    
    var body: some View {
        NavBarBody(displayConnection: $displayConnection, serverConnection: $serverConnection, title: "精算"){
            GeometryReader {geometry in
                HStack(spacing:0){
                    ChargeInputView()
                    Divider()
                    VStack(alignment: .leading){
                        ChargeInfo(title: "あるべき釣り銭(A)", amount: 0)
                            .padding(.bottom)
                            .padding(.top, 50)
                        ChargeInfo(title: "現在の釣り銭(B)", amount: 0)
                            .padding(.bottom)
                        ChargeInfo(title: "誤差(B-A)", amount: 0)
                        Spacer()
                        TitleButton(title: "精算完了", bgColor: Color.cyan, fgColor: Color.white, destination: {HomeView(isTraining: isTraining)})
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
    @State private var title: String
    @State private var amount: Int
    
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
    var body: some View {
        VStack(spacing: 0){
            
            Form {
                Section(header:
                            Text("釣り銭入力")
                    .font(.title)
                    .fontWeight(.semibold)
                ){
                    DenominationForm(denomination: 10000, quantity: 0)
                    DenominationForm(denomination: 5000, quantity: 0)
                    DenominationForm(denomination: 2000, quantity: 0)
                    DenominationForm(denomination: 1000, quantity: 0)
                    DenominationForm(denomination: 500, quantity: 0)
                    DenominationForm(denomination: 100, quantity: 0)
                    DenominationForm(denomination: 50, quantity: 0)
                    DenominationForm(denomination: 10, quantity: 0)
                    DenominationForm(denomination: 5, quantity: 0)
                    DenominationForm(denomination: 1, quantity: 0)
                }
                
                
            }
            Divider()
            HStack(){
                Text("合計")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Spacer()
                Text("¥0")
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
    var denomination: Int
    @State private var quantity: Int?
    var amount: Int? {
        if let quantity = quantity {
            return denomination * quantity
        } else {
            return nil
        }
    }
    // @Bindingでいい感じにamountを渡してtotalAmountを出したかったんですが、私の気力不足で実現しませんでした
    
    init(denomination: Int, quantity: Int) {
        self.denomination = denomination
        self._quantity = State(initialValue: quantity)
    }
    
    var body: some View {
        
        
        HStack(alignment: .center){
            HStack(){
                Text("")
                Spacer()
                Text("\(denomination)円")
                
            }
            .frame(maxWidth: 100)
            
            
            Spacer()
            Text("×")
                .padding(.trailing)
            TextField("0", value: $quantity, formatter: NumberFormatter())
                .multilineTextAlignment(.trailing)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 180)
            
            
            Text("=")
            HStack(){
                Spacer()
                Text("¥\(amount ?? 0)")
                
                
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
