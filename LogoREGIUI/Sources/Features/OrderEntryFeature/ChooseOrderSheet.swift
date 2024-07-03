//
//  ChooseOrderSheet.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/10/08.
//

import SwiftUI
import LogoREGICore

struct ChooseOrderSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var selection = 0
    @State private var seats: [Seat] = [Seat]()
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
    
    func getGroupName() -> String {
        switch(selection) {
        case 0:
            return "カウンター"
        case 1:
            return "テーブル"
        default:
            return ""
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
                
                Spacer()
                
                ForEach(seats, id: \.id) { seat in
                    if seat.name.hasPrefix(getGroupName()) {
                        Button(action: {
                            Task {
                                self.orders = await GetUnpaidOrdersById().Execute(seatId: seat.id)
                                self.isOrderSheet = true
                                dismiss()
                            }
                        }, label: {
                            VStack(spacing: 0) {
                                Text("\(seat.name)")
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                    .lineLimit(0)
                            }
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, minHeight: 25, alignment: .center)
                            .clipped()
                            .padding(.vertical, 8)
                            .background {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color.green)
                            }
                            .padding(8)
                        })
                    }
                }
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
        .task {
            seats = await GetSeats().Execute()
        }
    }
}
