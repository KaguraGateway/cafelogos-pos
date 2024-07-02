//
//  NavigationBarView.swift
//
//
//  Created by Owner on 2024/07/02.
//

import SwiftUI
import ComposableArchitecture

struct NavigationBarView: View {
    @Bindable var store: StoreOf<NavigationBarFeature>

    var body: some View {
        NavigationStack {
            VStack {
                // ここにコンテンツを配置
            }
            .background(Color(.secondarySystemBackground))
            .navigationTitle(store.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 10) {
                        VStack {
                            Image(systemName: store.serverConnection ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(store.serverConnection ? .green : .red)
                            Text("サーバー通信")
                                .foregroundColor(store.serverConnection ? .green : .red)
                        }
                        Button("ドロアを開く") {
                            store.send(.openDrawer)
                        }
                    }
                }
            }
        }
        .onAppear { store.send(.onAppear) }
    }
}

#Preview {
    NavigationBarView(
        store: Store(initialState: NavigationBarFeature.State(title: "ホーム")) {
            NavigationBarFeature()
        }
    )
}
