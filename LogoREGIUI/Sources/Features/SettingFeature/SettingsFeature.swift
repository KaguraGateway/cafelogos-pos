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
        
        var textFieldDebounceTask: Task<Void, Never>?
        
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
        case debouncedSaveConfig
        case toggleValueChanged
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.loadConfig)
            case .onDisappear:
                state.textFieldDebounceTask?.cancel()
                state.textFieldDebounceTask = nil
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
                    return .none
                }
                return .none
                
            case .toggleValueChanged:
                return .send(.saveConfig)
                
            case .debouncedSaveConfig:
                state.textFieldDebounceTask?.cancel()
                
                state.textFieldDebounceTask = Task {
                    do {
                        try await Task.sleep(nanoseconds: 500_000_000)
                        await MainActor.run {
                            ViewStore(self, observe: { $0 }).send(.saveConfig)
                        }
                    } catch {}
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
                    // Only update if values have changed
                    if state.clientName != state.config.clientName {
                        updatedConfig.clientName = state.clientName
                    }
                    if state.usePrinter != state.config.isUsePrinter {
                        updatedConfig.isUsePrinter = state.usePrinter
                    }
                    if state.printKitchenReceipt != state.config.isPrintKitchenReceipt {
                        updatedConfig.isPrintKitchenReceipt = state.printKitchenReceipt
                    }
                    if state.isUseSquareTerminal != state.config.isUseSquareTerminal {
                        updatedConfig.isUseSquareTerminal = state.isUseSquareTerminal
                    }
                    if state.squareAccessToken != state.config.squareAccessToken {
                        updatedConfig.squareAccessToken = state.squareAccessToken
                    }
                    if state.squareTerminalDeviceId != state.config.squareTerminalDeviceId {
                        updatedConfig.squareTerminalDeviceId = state.squareTerminalDeviceId
                    }
                    if state.hostUrl != state.config.hostUrl {
                        updatedConfig.hostUrl = state.hostUrl
                    }
                    if state.adminUrl != state.config.adminUrl {
                        updatedConfig.adminUrl = state.adminUrl
                    }
                    if state.isUseProductMock != state.config.isUseProductMock {
                        updatedConfig.isUseProductMock = state.isUseProductMock
                    }
                    if state.isUseIndividualBilling != state.config.isUseIndividualBilling {
                        updatedConfig.isUseIndividualBilling = state.isUseIndividualBilling
                    }
                    if state.ticketNumberPrefix != state.config.ticketNumberPrefix {
                        updatedConfig.ticketNumberPrefix = state.ticketNumberPrefix
                    }
                    if state.ticketNumberStart != state.config.ticketNumberStart {
                        updatedConfig.ticketNumberStart = state.ticketNumberStart
                    }
                    if state.isUseTicketNumber != state.config.isUseTicketNumber {
                        updatedConfig.isUseTicketNumber = state.isUseTicketNumber
                    }
                    
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
