//
//  OrderServiceServer.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/11.
//

import Foundation
import cafelogos_grpc
import Dependencies

public struct PaymentServiceServer: PaymentService {
    @Dependency(\.configRepository) var configRepo
    
    private let posClient = ServerClient().GetPosClient()
    
    func postPayment(payment: Payment, postOrder: Order?) async -> PostPaymentResponse {
        let request = Cafelogos_Pos_PostPaymentRequest.with {
            $0.payment = Cafelogos_Pos_Payment.with {
                $0.id = payment.id
                $0.type = Cafelogos_Pos_Payment.PaymentType(rawValue: payment.type.rawValue) ?? Cafelogos_Pos_Payment.PaymentType.cash
                $0.receiveAmount = payment.receiveAmount
                $0.paymentAmount = payment.paymentAmount
                $0.changeAmount = UInt64(payment.changeAmount)
                $0.paymentAt = payment.paymentAt.ISO8601Format()
                $0.updatedAt = payment.updatedAt.ISO8601Format()
                if postOrder != nil {
                    $0.postOrders = [
                        Cafelogos_Pos_OrderParam.with {
                            $0.id = postOrder!.id
                            $0.clientID = configRepo.load().clientId
                            $0.orderAt = Date().ISO8601Format()
                            $0.orderType = Cafelogos_Pos_OrderType.takeOut
                            $0.items = postOrder!.cart.items.map { item in
                                Cafelogos_Pos_OrderItem.with {
                                    $0.productID = item.productId
                                    $0.amount = item.productAmount
                                    $0.quantity = item.getQuantity()
                                    $0.coffeeBrewID = item.coffeeHowToBrew?.id ?? ""
                                }
                            }
                        }
                    ]
                }
                $0.orderIds = payment.orderIds
            }
        }
        let response = await posClient.postPayment(request: request, headers: [:])
        print(response)
        return PostPaymentResponse(callNumber: response.message?.orderResponses.count != 0 ? response.message?.orderResponses[0].callNumber : "", error: response.error)
    }
    
    func updatePayment(payment: Payment) async {
        let request = Cafelogos_Pos_UpdatePaymentRequest.with {
            $0.payment = Cafelogos_Pos_Payment.with {
                $0.id = payment.id
                $0.type = Cafelogos_Pos_Payment.PaymentType(rawValue: payment.type.rawValue) ?? Cafelogos_Pos_Payment.PaymentType.cash
                $0.receiveAmount = payment.receiveAmount
                $0.paymentAmount = payment.paymentAmount
                $0.changeAmount = UInt64(payment.changeAmount)
                $0.paymentAt = payment.paymentAt.ISO8601Format()
                $0.updatedAt = payment.updatedAt.ISO8601Format()
                $0.orderIds = payment.orderIds
            }
        }
        let response = await posClient.updatePayment(request: request, headers: [:])
        print(response)
    }
}
