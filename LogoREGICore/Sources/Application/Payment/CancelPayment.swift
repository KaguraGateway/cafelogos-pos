//
//  CancelPayment.swift
//  cafelogos-pos
//

import Foundation
import Dependencies

public enum CancelPaymentError: Error, Equatable {
    /// 対象の決済が見つからない
    case notFound
    /// すでに取消済み
    case alreadyCanceled
    /// 現金以外の決済は取消できない
    case unsupportedPaymentType
    /// サーバーへの取消リクエストが失敗した
    case serverError(String)
}

public struct CancelPayment {
    @Dependency(\.serverPaymentService) var paymentService
    @Dependency(\.paymentRepository) var paymentRepo
    @Dependency(\.cashierAdapter) var cashierAdapter
    @Dependency(\.configRepository) var configRepo
    
    public init() {}
    
    /// 決済済みの取引を取り消す。
    /// サーバーの取消が成功した場合のみローカルDBを取消済みに更新するため、サーバーとの不整合は発生しない。
    public func Execute(paymentId: String) async -> CancelPaymentError? {
        guard let payment = paymentRepo.findById(paymentId: paymentId) else {
            return .notFound
        }
        if payment.isCanceled {
            return .alreadyCanceled
        }
        // 外部決済の返金は端末側で行う必要があるため、POSからは取消できない
        if payment.type != .cash {
            return .unsupportedPaymentType
        }
        
        if let error = await paymentService.cancelPayment(paymentId: paymentId) {
            print("CancelPayment: サーバーの取消に失敗しました: \(error.localizedDescription)")
            return .serverError(error.localizedDescription)
        }
        
        paymentRepo.cancel(paymentId: paymentId, canceledAt: Date())
        
        // 返金のためにドロアを開ける
        if configRepo.load().isUsePrinter {
            await cashierAdapter.openCacher()
        }
        
        return nil
    }
}
