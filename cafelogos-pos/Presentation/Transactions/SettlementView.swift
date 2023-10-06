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
    @State private var deviceName = ""
    
    @State var denominations = Denominations(denominations: [
        Denomination(amount: 10000, quantity: 5), // 50000yen
        Denomination(amount: 5000, quantity: 2), // 10000yen
        Denomination(amount: 1000, quantity: 10), // 10000yen
        Denomination(amount: 500, quantity: 20), // 10000yen
        Denomination(amount: 100, quantity: 50), // 5000yen
        Denomination(amount: 50, quantity: 50), // 2500yen
        Denomination(amount: 10, quantity: 50), // 500yen
        Denomination(amount: 5, quantity: 50), // 250yen
        Denomination(amount: 1, quantity: 50) // 50yen
    ])
    
    
    var body: some View {
        NavBarBody(displayConnection: $displayConnection, serverConnection: $serverConnection, title: "精算"){
            GeometryReader {geometry in
                HStack(spacing:0){
                    ChargeInputView(denominations: $denominations)
                    Divider()
                    VStack(alignment: .leading){
                        ChargeInfo(title: "あるべき釣り銭(A)", amount: 0)
                            .padding(.bottom)
                            .padding(.top, 50)
                        ChargeInfo(title: "現在の釣り銭(B)", amount: 0)
                            .padding(.bottom)
                        ChargeInfo(title: "誤差(B-A)", amount: 0)
                        Spacer()
                        multi1Button(title: "精算完了", bgColor: Color.cyan, fgColor: Color.white, destination: {HomeView()})
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
    @Binding var denominations: Denominations
    
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
    @Binding var denomination: Denomination
    
    var body: some View {
        HStack(alignment: .center){
            HStack(){
                Text("")
                Spacer()
                Text("\(denomination.total())円")
                
            }
            .frame(maxWidth: 100)
            
            
            Spacer()
            Text("×")
                .padding(.trailing)
            TextField("0", value: Binding(get: { denomination.quantity }, set: { denomination.setQuantity(newValue: $0) }), formatter: NumberFormatter())
                .multilineTextAlignment(.trailing)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 180)
            
            
            Text("=")
            HStack(){
                Spacer()
                Text("¥\(denomination.amount)")
                
                
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
