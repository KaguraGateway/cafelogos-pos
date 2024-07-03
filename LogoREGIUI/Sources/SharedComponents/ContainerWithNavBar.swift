//
//  SwiftUIView.swift
//  
//  
//  Created by　KaguraGateway on 2024/07/03
//  
//

import SwiftUI

struct ContainerWithNavBar<Content : View>: View {
    @Environment(\.isServerConnected) private var isServerConnected;
    
    let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        // contentにそのままmodifyつけると事故るからVStackでラップしてる (https://github.com/KaguraGateway/cafelogos-pos/pull/41#discussion_r1663347407)
        VStack(spacing: 0.0) {
            content
        }
            .background(Color(.secondarySystemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 10) {
                        ConnectionStatus(connectionStatus: isServerConnected, connectionName: "サーバー通信")
                        Button(action: {}) {
                            Text("ドロアを開く")
                        }
                    }
                }
            }
    }
}

#Preview {
    ContainerWithNavBar {
        VStack {
            Text("Hello World")
        }
    }
}
