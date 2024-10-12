// カスタマーディスプレイのView

import SwiftUI

struct CustomerdisplaySetting: View {
    @State private var displayConnection: Bool = false
    @State private var useCustomerdisplay: Bool = false
    var ipAddr: String = "192.168.x.x:3000"
    var wifiSsid: String = "SAZAE-WLAP"
    
    var body: some View {
        Form{
            Toggle("カスタマーディスプレイ利用", isOn: $useCustomerdisplay)
            if useCustomerdisplay {
                HStack(){
                    Text("接続ステータス")
                    Spacer()
                    Text(displayConnection ? "接続中" : "未接続")
                        .foregroundColor(.secondary)
                    
                    
                }
                Section{
                    HStack(){
                        Text("WiFiアクセスポイント名")
                        Spacer()
                        Text(wifiSsid)
                            .foregroundColor(.secondary)
                    }
                    HStack(){
                        Text("IPアドレス")
                        Spacer()
                        Text(ipAddr)
                            .foregroundColor(.secondary)
                    }
                    HStack(alignment: .center){
                        Spacer()
                        Text("表示されているQRコードを読み取ることで、\nカスタマーディスプレイに接続することができます。")
                            .font(.system(.body))
                        Spacer()
                        
                        Rectangle()
                            .frame(width: 250, height: 250)
                        Spacer()
                    }
                    
                    .padding(.vertical, 30)
                    
                }header: {
                    Text("接続情報")
                }
                
                
            }
        }
        .padding(.horizontal, 120)
    }
}


#Preview {
    CustomerdisplaySetting()
        .previewInterfaceOrientation(.landscapeRight)
        .previewDevice("iPad Pro (11-inch) (4th generation)")
}
