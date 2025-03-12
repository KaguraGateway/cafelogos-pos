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
        var isUseIndividualBilling: Bool = false
        
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
            self.isUseProductMock = config.isUseProductMock
            self.isUseIndividualBilling = config.isUseIndividualBilling
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
                // 値が変更されたら即座に保存する
                return .run { send in
                    await send(.saveConfig)
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
                    // 新しいConfigインスタンスを作成して、最新のstate値を直接設定する
                    let updatedConfig = Config(
                        clientId: state.clientId,
                        clientName: state.clientName,
                        isTrainingMode: state.config.isTrainingMode,
                        isUsePrinter: state.usePrinter,
                        isPrintKitchenReceipt: state.printKitchenReceipt,
                        isUseSquareTerminal: state.isUseSquareTerminal,
                        squareAccessToken: state.squareAccessToken,
                        squareTerminalDeviceId: state.squareTerminalDeviceId,
                        hostUrl: state.hostUrl,
                        isUseProductMock: state.isUseProductMock,
                        isUseIndividualBilling: state.isUseIndividualBilling
                    )
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
                state.isUseProductMock = config.isUseProductMock
                state.isUseIndividualBilling = config.isUseIndividualBilling
                return .none
            }
        }
    }
}
