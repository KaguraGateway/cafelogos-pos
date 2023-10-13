//
//  ChooseOrderSheet.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/10/08.
//

import SwiftUI

extension UISegmentedControl {
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
}

struct ChooseOrderSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var selection = 0
    @State private var inputValue = ""
    @Binding var orders: [Order]
    @Binding var isOrderSheet: Bool
    
    init(orders: Binding<[Order]>, isOrderSheet: Binding<Bool>) {
        self._orders = orders
        self._isOrderSheet = isOrderSheet
        let semiboldFont = UIFont.boldSystemFont(ofSize: 30)
        
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.font : semiboldFont],
            for: .normal
        )
    }
    
    func getSeatName() -> String {
        switch(selection) {
        case 0:
            return "カウンター\(inputValue)"
        case 1:
            return "テーブル\(inputValue)"
        default:
            return inputValue
        }
    }
    
    
    var body: some View {
        NavigationStack() {
            VStack(spacing:0){
                Divider()
                VStack(spacing: 0) {
                    Picker(selection: $selection, label: Text("Order")) {
                        Text("カウンター").tag(0)
                        Text("テーブル").tag(1)
                        Text("その他").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .frame(maxHeight: 300)
                .padding(20)
                
                InputForm(selection: $selection, inputValue: $inputValue)
                Spacer()
                Button(action: {
                    Task {
                        self.orders = await GetUnpaidOrdersBySeatName().Execute(seatName: getSeatName())
                        self.isOrderSheet = true
                        dismiss()
                    }
                }, label: {
                    VStack(spacing: 0) {
                        Text("完了")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .lineLimit(0)
                    }
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, minHeight: 50, alignment: .center)
                    .clipped()
                    .padding(.vertical, 20)
                    .background {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color.green)
                    }
                    .padding(20)
                })
            }
            .background(Color(.secondarySystemBackground))
            .navigationTitle("伝票選択")
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

struct InputForm: View {
    @Binding var selection: Int
    @Binding var inputValue: String
    
    var body: some View {
        if selection == 0 || selection == 1 {
            TextField("座席番号を入力", text: $inputValue)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .padding()
        } else {
            TextField("文字列を入力", text: $inputValue)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .padding()
        }
    }
}

//
//#Preview {
//    ChooseOrderSheet()
//}
