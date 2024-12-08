import Foundation
import Dependencies

public struct HandleLaunchWithOpenURL {
    @Dependency(\.externalPaymentService) private var externalPaymentService
    
    public init() {}
    
    public func Execute(url: URL) -> Bool {
        if(externalPaymentService.isExternalPaymentResponse(url: url)) {
            let res = externalPaymentService.handleExternalPaymentResponse(url: url)
            if res.error != nil {
                print(res.error?.localizedDescription ?? "")
                return false
            }
        }
        return true
    }
}
