import Foundation
import Dependencies

public struct DrawerTest {
    @Dependency(\.cashierAdapter) var cashierAdapter
    
    public init() {}
    
    public func Execute() async {
        await cashierAdapter.openCacher()
    }
}
