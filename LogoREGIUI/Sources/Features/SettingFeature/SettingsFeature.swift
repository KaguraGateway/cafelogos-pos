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
        var adminUrl: String = ""
        
        var isUseSquareTerminal: Bool = false
        var squareAccessToken: String = ""
        var squareTerminalDeviceId: String = ""
        
        var isUseProductMock: Bool = false
        var isUseIndividualBilling: Bool = false
        
        var ticketNumberPrefix: String = "L"
        var ticketNumberStart: Int = 1
        var isUseTicketNumber: Bool = false
        
        var config: Config

        
        init() {
            self.config = GetConfig().Execute()
            self.clientId = config.clientId
            self.clientName = config.clientName
            self.usePrinter = config.isUsePrinter
            self.printKitchenReceipt = config.isPrintKitchenReceipt
            self.hostUrl = config.hostUrl
            self.adminUrl = config.adminUrl
            self.isUseSquareTerminal = config.isUseSquareTerminal
            self.squareAccessToken = config.squareAccessToken
            self.squareTerminalDeviceId = config.squareTerminalDeviceId
            self.isUseProductMock = config.isUseProductMock
            self.isUseIndividualBilling = config.isUseIndividualBilling
            self.ticketNumberPrefix = config.ticketNumberPrefix
            self.ticketNumberStart = config.ticketNumberStart
            self.isUseTicketNumber = config.isUseTicketNumber
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
                    state.adminUrl != state.config.adminUrl ||
                    state.isUseProductMock != state.config.isUseProductMock ||
                    state.isUseIndividualBilling != state.config.isUseIndividualBilling ||
                    state.ticketNumberPrefix != state.config.ticketNumberPrefix ||
                    state.ticketNumberStart != state.config.ticketNumberStart ||
                    state.isUseTicketNumber != state.config.isUseTicketNumber
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
                    updatedConfig.adminUrl = state.adminUrl
                    updatedConfig.isUseProductMock = state.isUseProductMock
                    updatedConfig.isUseIndividualBilling = state.isUseIndividualBilling
                    updatedConfig.ticketNumberPrefix = state.ticketNumberPrefix
                    updatedConfig.ticketNumberStart = state.ticketNumberStart
                    updatedConfig.isUseTicketNumber = state.isUseTicketNumber
                    
                    // Only save if any value has changed
                    if updatedConfig != state.config {
                        SaveConfig().Execute(config: updatedConfig)
                    }
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
                state.adminUrl = config.adminUrl
                state.isUseProductMock = config.isUseProductMock
                state.isUseIndividualBilling = config.isUseIndividualBilling
                state.ticketNumberPrefix = config.ticketNumberPrefix
                state.ticketNumberStart = config.ticketNumberStart
                state.isUseTicketNumber = config.isUseTicketNumber
                return .none
            }
        }
    }
}
