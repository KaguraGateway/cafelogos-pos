import Foundation
import Dependencies

public struct CashierTest {
    @Dependency(\.cashierAdapter) var cashierAdapter
    
    public init() {}
    
    public func Execute() async {
        await cashierAdapter.openCacher()
        await cashierAdapter.printReceipt(receipt: OrderReceipt(callNumber: "L-1"))
    }
}
