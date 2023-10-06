//
//  ChooseOrderView.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/10/05.
//

import SwiftUI

extension UISegmentedControl {
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.setContentHuggingPriority(.defaultLow, for: .vertical)  // << here !!
    }
}

struct ChooseOrderView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectionValue: Int? = nil
    @State var toggle = false
    @State private var selection = 3
    
    init() {
            UISegmentedControl.appearance().setTitleTextAttributes(
                [.font : UIFont.systemFont(ofSize: 50)], for: .normal
            )
        }
    
    var body: some View {
        NavigationStack() {
            VStack(spacing:0){
                Divider()
                HStack(spacing:0){
                    //左
                    GeometryReader { geometry in
                        VStack(spacing: 0) {
                            Picker(selection: $selection, label: Text("Fruit")) {
                                         Text("sazae").tag(0)
                                         Text("go").tag(1)
                                         Text("go").tag(2)
                                     }
                            .pickerStyle(SegmentedPickerStyle()
                            )
                                     .padding()
                                     Text("選択したフルーツ:\(selection)")
                        }
                        .frame(maxHeight: 400)
                    }
                    .frame(maxWidth: .infinity)
                }
                .background(Color(.secondarySystemBackground))
            }
            
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



#Preview {
    ChooseOrderView()
}
