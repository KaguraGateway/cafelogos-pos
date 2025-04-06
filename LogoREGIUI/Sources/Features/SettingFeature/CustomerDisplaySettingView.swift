//
//
//

import SwiftUI
import ComposableArchitecture
import Network

struct CustomerDisplaySettingView: View {
    @Bindable var store: StoreOf<SettingsFeature>
    @State private var displayConnection: Bool = false
    @State private var ipAddress: String = "取得中..."
    
    var body: some View {
        Section {
            HStack {
                Text("接続ステータス")
                Spacer()
                Text(displayConnection ? "接続中" : "未接続")
                    .foregroundStyle(.secondary)
            }
            
            Section {
                HStack {
                    Text("IPアドレス")
                    Spacer()
                    Text(ipAddress)
                        .foregroundStyle(.secondary)
                }
                
                HStack(alignment: .center) {
                    Spacer()
                    Text("表示されているIPアドレスとポート8090にアクセスすることで、\nカスタマーディスプレイに接続することができます。")
                        .font(.system(.body))
                    Spacer()
                    
                    VStack {
                        Text("http://\(ipAddress):8090")
                            .font(.system(.title3, weight: .bold))
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    }
                    .frame(width: 250, height: 100)
                    Spacer()
                }
                .padding(.vertical, 30)
                
            } header: {
                Text("接続情報")
            }
        } header: {
            Text("カスタマーディスプレイ設定")
        }
        .onAppear {
            checkServerConnection()
            
            getIPAddress()
        }
    }
    
    private func checkServerConnection() {
        let url = URL(string: "http://localhost:8090")!
        let task = URLSession.shared.dataTask(with: url) { _, response, _ in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse {
                    displayConnection = (httpResponse.statusCode == 200)
                } else {
                    displayConnection = false
                }
            }
        }
        task.resume()
    }
    
    private func getIPAddress() {
        var ipAddress = "接続情報を取得できません"
        
        let networkInterfaces = NWPathMonitor()
        networkInterfaces.pathUpdateHandler = { path in
            if path.status == .satisfied {
                if let ipAddressString = getWiFiAddress() {
                    DispatchQueue.main.async {
                        self.ipAddress = ipAddressString
                    }
                }
            }
            networkInterfaces.cancel()
        }
        networkInterfaces.start(queue: DispatchQueue.global())
    }
}

func getWiFiAddress() -> String? {
    var address: String?
    
    var ifaddr: UnsafeMutablePointer<ifaddrs>?
    guard getifaddrs(&ifaddr) == 0 else { return nil }
    guard let firstAddr = ifaddr else { return nil }
    
    defer { freeifaddrs(ifaddr) }
    
    for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
        let interface = ifptr.pointee
        
        let addrFamily = interface.ifa_addr.pointee.sa_family
        if addrFamily == UInt8(AF_INET) {
            let name = String(cString: interface.ifa_name)
            if name == "en0" {
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                           &hostname, socklen_t(hostname.count),
                           nil, socklen_t(0), NI_NUMERICHOST)
                address = String(cString: hostname)
            }
        }
    }
    
    return address
}
