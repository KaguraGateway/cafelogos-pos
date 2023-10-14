//
//  DI.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/06.
//

import Foundation
import Dependencies
import Connect
import cafelogos_grpc

private enum DenominationRepositoryKey: DependencyKey {
    static let liveValue: any DenominationRepository = DenominationRealm()
}
private enum PaymentRepositoryKey: DependencyKey {
    static let liveValue: any PaymentRepository = PaymentRealm()
}
private enum OrderRepositoryKey: DependencyKey {
    static let liveValue: any OrderRepository = OrderRealm()
}
private enum ConfigRepositoryKey: DependencyKey {
    static let liveValue: any ConfigRepository = ConfigAppStorage()
}

private enum GrpcClientKey: DependencyKey {
    static let liveValue: ProtocolClient = ProtocolClient(
        httpClient: URLSessionHTTPClient(), config: ProtocolClientConfig(
            //host: "https://cafelogos-pos-backend-qlrb2to2zq-an.a.run.app",
            host: "http://192.168.11.4:8080",
            networkProtocol: .connect,
            codec: ProtoCodec()
        )
    )
}

private enum ServerProductQueryServiceKey: DependencyKey {
    static let liveValue: any ProductQueryService = ProductQueryServiceServer()
}
private enum ServerDiscountRepositoryKey: DependencyKey {
    static let liveValue: any DiscountRepository = DiscountRepositoryServer()
}
private enum PaymentServerServiceKey: DependencyKey {
    static let liveValue: any PaymentService = PaymentServiceServer()
}
private enum SeatServerRepositoryKey: DependencyKey {
    static let liveValue: any SeatRepository = SeatRepositoryServer()
}
private enum OrderServerServiceKey: DependencyKey {
    static let liveValue: any OrderService = OrderServiceServer()
}
private enum OrderReceiptKey: DependencyKey {
    static let liveValue: any OrderReceiptService = OrderReceiptStarX()
}

extension DependencyValues {
    var denominationRepository: any DenominationRepository {
        get { self[DenominationRepositoryKey.self] }
        set { self[DenominationRepositoryKey.self] = newValue }
    }
    var paymentRepository: any PaymentRepository {
        get { self[PaymentRepositoryKey.self] }
        set { self[PaymentRepositoryKey.self] = newValue }
    }
    var orderRepository: any OrderRepository {
        get { self[OrderRepositoryKey.self] }
        set { self[OrderRepositoryKey.self] = newValue }
    }
    var configRepository: any ConfigRepository {
        get { self[ConfigRepositoryKey.self] }
        set{ self[ConfigRepositoryKey.self] = newValue }
    }
    var grpcClient: ProtocolClient {
        get { self[GrpcClientKey.self] }
        set { self[GrpcClientKey.self] = newValue }
    }
    var serverProductQS: any ProductQueryService {
        get { self[ServerProductQueryServiceKey.self] }
        set { self[ServerProductQueryServiceKey.self] = newValue }
    }
    var serverDiscountRepository: any DiscountRepository {
        get { self[ServerDiscountRepositoryKey.self] }
        set { self[ServerDiscountRepositoryKey.self] = newValue }
    }
    var serverSeatRepository: any SeatRepository {
        get { self[SeatServerRepositoryKey.self] }
        set { self[SeatServerRepositoryKey.self] = newValue }
    }
    var serverPaymentService: any PaymentService {
        get { self[PaymentServerServiceKey.self] }
        set { self[PaymentServerServiceKey.self] = newValue }
    }
    var serverOrderService: any OrderService {
        get { self[OrderServerServiceKey.self] }
        set { self[OrderServerServiceKey.self] = newValue }
    }
    var orderReceipt: any OrderReceiptService {
        get { self[OrderReceiptKey.self] }
        set { self[OrderReceiptKey.self] = newValue }
    }
}
