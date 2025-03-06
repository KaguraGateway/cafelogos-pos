// 設定画面のFeature

import Foundation
import ComposableArchitecture
import LogoREGICore

@Reducer
public struct SettingsFeature {
    @ObservableState
    public struct State: Equatable {
        var usePrinter: Bool = true
        var printTicket: Bool = true
        var useDrawer: Bool = true
        var printKitchenReceipt: Bool = true
        var clientId: String = ""
        var clientName: String = ""
        var hostUrl: String = ""
        
        var isUseSquareTerminal: Bool = false
        var squareAccessToken: String = ""
        var squareTerminalDeviceId: String = ""
        
        var isUseProductMock: Bool = false
        
        var config: Config
        
        init() {
            // デフォルト設定で初期化
            let defaultConfig = Config()
            self.config = defaultConfig
            self.clientId = defaultConfig.clientId
            self.clientName = defaultConfig.clientName
            self.usePrinter = defaultConfig.isUsePrinter
            self.printKitchenReceipt = defaultConfig.isPrintKitchenReceipt
            self.hostUrl = defaultConfig.hostUrl
            self.isUseSquareTerminal = defaultConfig.isUseSquareTerminal
            self.squareAccessToken = defaultConfig.squareAccessToken
            self.squareTerminalDeviceId = defaultConfig.squareTerminalDeviceId
            self.isUseProductMock = defaultConfig.isUseProductMock
        }
    }
    
    public enum Action: BindableAction {
        case onAppear
        case onDisappear
        case binding(BindingAction<State>)
        case openDrawer
        case printTicket
        case saveConfig
        case loadConfig
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.loadConfig)
            case .onDisappear:
                return .send(.saveConfig)
            case .binding:
                if state.clientName != state.config.clientName ||
                    state.usePrinter != state.config.isUsePrinter ||
                    state.printKitchenReceipt != state.config.isPrintKitchenReceipt ||
                    state.isUseSquareTerminal != state.config.isUseSquareTerminal ||
                    state.squareAccessToken != state.config.squareAccessToken ||
                    state.squareTerminalDeviceId != state.config.squareTerminalDeviceId ||
                    state.hostUrl != state.config.hostUrl ||
                    state.isUseProductMock != state.config.isUseProductMock
                {
                    return .run { send in
                        await send(.saveConfig)
                    }
                }
                return .none
            case .printTicket:
                return .run {_ in
                    await PrinterTest().Execute()
                }
            case .openDrawer:
                return .run { _ in
                    await DrawerTest().Execute()
                }
            case .saveConfig:
                return .run { [state] _ in
                    var updatedConfig = state.config
                    updatedConfig.clientName = state.clientName
                    updatedConfig.isUsePrinter = state.usePrinter
                    updatedConfig.isPrintKitchenReceipt = state.printKitchenReceipt
                    updatedConfig.isUseSquareTerminal = state.isUseSquareTerminal
                    updatedConfig.squareAccessToken = state.squareAccessToken
                    updatedConfig.squareTerminalDeviceId = state.squareTerminalDeviceId
                    updatedConfig.hostUrl = state.hostUrl
                    updatedConfig.isUseProductMock = state.isUseProductMock
                    await SaveConfig().Execute(config: updatedConfig)
                }
            case .loadConfig:
                return .run { send in
                    let config = await GetConfig().Execute()
                    await send(.binding(.set(\.$config, config)))
                    await send(.binding(.set(\.$clientId, config.clientId)))
                    await send(.binding(.set(\.$clientName, config.clientName)))
                    await send(.binding(.set(\.$usePrinter, config.isUsePrinter)))
                    await send(.binding(.set(\.$printKitchenReceipt, config.isPrintKitchenReceipt)))
                    await send(.binding(.set(\.$isUseSquareTerminal, config.isUseSquareTerminal)))
                    await send(.binding(.set(\.$squareAccessToken, config.squareAccessToken)))
                    await send(.binding(.set(\.$squareTerminalDeviceId, config.squareTerminalDeviceId)))
                    await send(.binding(.set(\.$hostUrl, config.hostUrl)))
                    await send(.binding(.set(\.$isUseProductMock, config.isUseProductMock)))
                }
            }
        }
    }
}
