import Foundation
import Dependencies

public struct PrinterTest {
    @Dependency(\.cashierAdapter) var cashierAdapter
    
    public init() {}
    
    public func Execute() async {
        await cashierAdapter.printReceipt(receipt: OrderReceipt(callNumber: "L-1"))
    }
}
