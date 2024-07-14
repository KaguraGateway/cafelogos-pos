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
        var clientId: String = ""
    }
    
    public enum Action {
        case toggleUsePrinter
        case togglePrintTicket
        case toggleUseDrawer
        case openDrawer
        case printReceipt
        case setClientId(String)
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .toggleUsePrinter:
                state.usePrinter.toggle()
                return .none
            case .togglePrintTicket:
                state.printTicket.toggle()
                return .none
            case .toggleUseDrawer:
                state.useDrawer.toggle()
                return .none
            case .openDrawer:
                return .run{ _ in await DrawerTest().Execute()}
            case .printReceipt:
                return .run{ _ in await PrinterTest().Execute()}
            case .setClientId(let id):
                state.clientId = id
                return .none
            }
        }
    }
}
