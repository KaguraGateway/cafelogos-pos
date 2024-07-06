// 一般設定のViewModel

import Foundation
import LogoREGICore

class GeneralSettingViewModel: ObservableObject {
    @Published private var config: Config
    
    public init() {
        self.config = GetConfig().Execute()
    }
    
    public var clientId: String {
        get {
            return self.config.clientId
        }
    }
    
    public var clientName: String {
        get {
            return self.config.clientName
        }
        set {
            self.config.clientName = newValue
            SaveConfig().Execute(config: config)
        }
    }
    
    func openCacher() {
        Task {
            await DrawerTest().Execute()
        }
    }
    
    func printReceipt() {
        Task {
            await PrinterTest().Execute()
        }
    }
}
