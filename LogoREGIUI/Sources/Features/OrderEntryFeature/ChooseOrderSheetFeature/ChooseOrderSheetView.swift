//
//  ChooseOrderSheet.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/10/08.
//

import SwiftUI
import LogoREGICore
import ComposableArchitecture

public struct ChooseOrderSheetView: View {
    @Bindable var store: StoreOf<ChooseOrderSheetFeature>
    
    @Environment(\.dismiss) var dismiss
    
    public init(store: StoreOf<ChooseOrderSheetFeature>) {
        self.store = store
        
        let semiboldFont = UIFont.boldSystemFont(ofSize: 30)
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.font : semiboldFont],
            for: .normal
        )
    }
    
    func getGroupName() -> String {
        switch(store.selectSeatType) {
        case 0:
            return "カウンター"
        case 1:
            return "テーブル"
        default:
            return ""
        }
    }
    
    public var body: some View {
        NavigationStack() {
            VStack(spacing:0){
                Divider()
                VStack(spacing: 0) {
                    Picker(selection: $store.selectSeatType.sending(\.changeSelectSeatType), label: Text("Order")) {
                        Text("カウンター").tag(0)
                        Text("テーブル").tag(1)
                        Text("その他").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .frame(maxHeight: 200)
                .padding(20)
                
                Spacer()
                
                ScrollView {
                    ForEach(store.seats, id: \.id) { seat in
                        if seat.name.hasPrefix(getGroupName()) {
                            Button(action: {
                                Task {
                                    store.send(.delegate(.getUnpaidOrdersById(seat.id)))
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
                        }}
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
        .onAppear {
            store.send(.fetchSeats)
        }
    }
}

// Picker要素のPaddingを調整するextension
extension UISegmentedControl {
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
}

