//
//  ConnectionStatus.swift
//
//
//  Created by Owner on 2024/07/02.
//

import SwiftUI

struct ConnectionStatus: View {
    var connectionStatus: Bool
    var connectionName: String
    
    var body: some View {
        VStack {
            Image(systemName: connectionStatus ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(connectionStatus ? .green : .red)
            Text(connectionName)
                .foregroundStyle(connectionStatus ? .green : .red)
        }
    }
}

#Preview {
    ConnectionStatus(connectionStatus: true, connectionName: "サーバー通信")
}
