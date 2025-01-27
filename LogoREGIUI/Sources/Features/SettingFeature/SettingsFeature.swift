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
        
        var config: Config
        
        init() {
            self.config = GetConfig().Execute()
            self.clientId = config.clientId
            self.clientName = config.clientName
            self.usePrinter = config.isUsePrinter
            self.printKitchenReceipt = config.isPrintKitchenReceipt
            self.hostUrl = config.hostUrl
            self.isUseSquareTerminal = config.isUseSquareTerminal
            self.squareAccessToken = config.squareAccessToken
            self.squareTerminalDeviceId = config.squareTerminalDeviceId
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
                    state.hostUrl != state.config.hostUrl
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
                    SaveConfig().Execute(config: updatedConfig)
                }
            case .loadConfig:
                let config = GetConfig().Execute()
                state.config = config
                state.clientId = config.clientId
                state.clientName = config.clientName
                state.usePrinter = config.isUsePrinter
                state.printKitchenReceipt = config.isPrintKitchenReceipt
                state.isUseSquareTerminal = config.isUseSquareTerminal
                state.squareAccessToken = config.squareAccessToken
                state.squareTerminalDeviceId = config.squareTerminalDeviceId
                state.hostUrl = config.hostUrl
                return .none
            }
        }
    }
}
