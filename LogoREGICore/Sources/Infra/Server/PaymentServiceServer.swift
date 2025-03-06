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
    private let formatter = ISO8601DateFormatter()
    
    // FIXME: ここの引数イケてなさすぎる
    func postPayment(payment: Payment, postOrder: Order?, externalPaymentType: String?) async -> PostPaymentResponse {
        let request = Cafelogos_Pos_PostPaymentRequest.with {
            $0.payment = Cafelogos_Pos_PaymentParam.with {
                $0.id = payment.id
                $0.type = Int32(payment.type.rawValue)
                $0.receiveAmount = payment.receiveAmount
                $0.paymentAmount = payment.paymentAmount
                $0.changeAmount = UInt64(payment.changeAmount)
                $0.paymentAt = payment.paymentAt.ISO8601Format()
                $0.updatedAt = payment.updatedAt.ISO8601Format()
                
                if payment.type == .external && externalPaymentType != nil {
                    $0.external = Cafelogos_Pos_PaymentExternalParam.with {
                        let config = await configRepo.load()
                        $0.externalDeviceID = config.squareTerminalDeviceId
                        $0.paymentType = externalPaymentType!
                    }
                }
            }
            if postOrder != nil {
                $0.postOrders = [
                    Cafelogos_Pos_OrderParam.with {
                        $0.id = postOrder!.id
                        $0.clientID = (await configRepo.load()).clientId
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
        let response = await posClient.postPayment(request: request, headers: [:])
        print(response)
        return PostPaymentResponse(callNumber: response.message?.orderResponses.count != 0 ? response.message?.orderResponses[0].callNumber : "", error: response.error)
    }
    
    // これ使ってる？
    func updatePayment(payment: Payment) async {
        let request = Cafelogos_Pos_UpdatePaymentRequest.with {
            $0.payment = Cafelogos_Pos_PaymentParam.with {
                $0.id = payment.id
                $0.type = Int32(payment.type.rawValue)
                $0.receiveAmount = payment.receiveAmount
                $0.paymentAmount = payment.paymentAmount
                $0.changeAmount = UInt64(payment.changeAmount)
                $0.paymentAt = payment.paymentAt.ISO8601Format()
                $0.updatedAt = payment.updatedAt.ISO8601Format()
            }
        }
        let response = await posClient.updatePayment(request: request, headers: [:])
        print(response)
    }
    
    func getPaymentExternal(paymentId: String) async -> PaymentExternal? {
        let request = Cafelogos_Pos_GetExternalPaymentRequest.with {
            $0.paymentID = paymentId
        }
        let response = await posClient.getExternalPayment(request: request, headers: [:])
        let resPaymentExternal = response.message?.externalPayment
        if resPaymentExternal == nil {
            return nil
        }
        // FIXME: paidAt代入忘れ（要: gRPC Proto修正）
        return PaymentExternal(
            id: resPaymentExternal!.id,
            paymentId: resPaymentExternal!.paymentID,
            paymentType: resPaymentExternal!.paymentType,
            status: resPaymentExternal!.status,
            externalServiceId: resPaymentExternal!.externalServiceID,
            externalDeviceId: resPaymentExternal!.externalDeviceID,
            createdAt: formatter.date(from: resPaymentExternal!.createdAt)!,
            updatedAt: formatter.date(from: resPaymentExternal!.updatedAt)!,
            paidAt: nil
        )
    }
}
