import Foundation
import SquarePointOfSaleSDK

public struct SquarePaymentService: ExternalPaymentService {
    static let CALLBACK_URL = URL(string: "logoregi://")!
    
    func isExternalPaymentResponse(url: URL) -> Bool {
        SCCAPIResponse.isSquareResponse(url)
    }
    
    func handleExternalPaymentResponse(url: URL) -> ExternalPaymentHandleResponseOutput {
        do {
            let response = try SCCAPIResponse(responseURL: url)
            
            if let error = response.error {
                print(error.localizedDescription)
                return ExternalPaymentHandleResponseOutput(error: error)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
            return ExternalPaymentHandleResponseOutput(error: error)
        }
        
        return ExternalPaymentHandleResponseOutput(error: nil)
    }
    
    func paymentRequest(payment: Payment) -> PaymentRequestOutput {
        SCCAPIRequest.setApplicationID("")
        
        do {
            let money = try SCCMoney(amountCents: Int(payment.paymentAmount), currencyCode: "JPY")
            
            let apiRequest = try SCCAPIRequest(
                callbackURL: SquarePaymentService.CALLBACK_URL,
                amount: money,
                userInfoString: nil,
                locationID: nil,
                notes: "",
                customerID: nil,
                supportedTenderTypes: .card,
                clearsDefaultFees: false,
                returnsAutomaticallyAfterPayment: false,
                disablesKeyedInCardEntry: false,
                skipsReceipt: true
            )
            
            try SCCAPIConnection.perform(apiRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
            return PaymentRequestOutput(error: error)
        }
        return PaymentRequestOutput(error: nil)
    }
}
