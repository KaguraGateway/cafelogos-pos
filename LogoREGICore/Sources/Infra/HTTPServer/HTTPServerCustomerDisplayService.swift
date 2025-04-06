//
//
//

import Foundation
import Swifter

public class HTTPServerCustomerDisplayService: CustomerDisplayService {
    private let httpServer: HttpServer
    private var apiDataStore: CustomerDisplayAPIDataStore
    
    public init() {
        httpServer = HttpServer()
        apiDataStore = CustomerDisplayAPIDataStore()
        
        let bundlePath = Bundle.main.path(forResource: "CustomerDisplay", ofType: nil)
        if let bundlePath = bundlePath {
            httpServer["/"] = shareFilesFromDirectory(bundlePath)
        }
        
        httpServer["/api/data"] = { request in
            do {
                let data = try JSONEncoder().encode(self.apiDataStore.currentData)
                return .ok(.data(data, contentType: "application/json"))
            } catch {
                print("APIデータエンコードエラー: \(error)")
                return .internalServerError
            }
        }
        
        do {
            try httpServer.start(8090)
            print("顧客モニター用サーバーを起動しました: http://localhost:8090")
        } catch {
            print("サーバー起動エラー: \(error)")
        }
    }
    
    public func updateOrder(orders: [Order]) {
        let items = orders.flatMap { order in
            order.cart.items.map { item in
                CustomerDisplayItem(
                    name: item.productName,
                    quantity: Int(item.quantity),
                    price: Int(item.productPrice),
                    brewMethod: item.coffeeHowToBrew?.name
                )
            }
        }
        
        apiDataStore.currentData.state = .entryList
        apiDataStore.currentData.items = items
        apiDataStore.currentData.totalAmount = Int(orders.reduce(0) { $0 + $1.totalAmount })
        apiDataStore.currentData.totalQuantity = Int(orders.reduce(0) { $0 + $1.cart.totalQuantity })
    }
    
    public func transitionPayment() {
        apiDataStore.currentData.state = .payment
    }
    
    public func transitionPaymentSuccess(payment: Payment) {
        apiDataStore.currentData.state = .thanks
        apiDataStore.currentData.receiveAmount = Int(payment.receiveAmount)
        apiDataStore.currentData.changeAmount = Int(payment.changeAmount)
    }
}

fileprivate class CustomerDisplayAPIDataStore {
    var currentData: CustomerDisplayData = CustomerDisplayData(
        state: .logo,
        items: [],
        totalAmount: 0,
        totalQuantity: 0,
        receiveAmount: 0,
        changeAmount: 0
    )
}

fileprivate struct CustomerDisplayData: Codable {
    var state: CustomerDisplayState
    var items: [CustomerDisplayItem]
    var totalAmount: Int
    var totalQuantity: Int
    var receiveAmount: Int
    var changeAmount: Int
}

fileprivate struct CustomerDisplayItem: Codable {
    var name: String
    var quantity: Int
    var price: Int
    var brewMethod: String?
}

fileprivate enum CustomerDisplayState: Int, Codable {
    case logo = 0
    case thanksUse = 1
    case entryList = 2
    case payment = 3
    case thanks = 4
    case ads = 5
    case ads2 = 6
}
