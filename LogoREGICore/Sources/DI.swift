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
import SwiftData

private enum DenominationRepositoryKey: DependencyKey {
    @MainActor
    static private(set) var liveValue: any DenominationRepository = {
        let container = ModelContainerFactory.shared
        return DenominationSwiftData(modelContainer: container)
    }()
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

private enum HostUrlKey: DependencyKey {
    static var liveValue: String = "http://localhost:8080"
}

private enum GrpcClientKey: DependencyKey {
    static var liveValue: ProtocolClient {
        let config = DependencyValues().configRepository.load()
        // 環境変数からhostUrlを取得する試み
        var hostUrl = ""
        if let environmentHostUrl = ProcessInfo.processInfo.environment["HOST_URL"], !environmentHostUrl.isEmpty {
            hostUrl = environmentHostUrl
        } else {
            // HostUrlUpdaterから最新のhostUrl値を取得
            let updatedHostUrl = HostUrlUpdater.getHostUrl()
            if updatedHostUrl != "http://localhost:8080" {
                hostUrl = updatedHostUrl
            } else {
                hostUrl = config.hostUrl.isEmpty ? "http://localhost:8080" : config.hostUrl
            }
        }
        
        return ProtocolClient(
            httpClient: URLSessionHTTPClient(),
            config: ProtocolClientConfig(
                //host: "https://cafelogos-pos-backend-z4ljh3ykiq-dt.a.run.app",
                //host: "http://192.168.11.24:8080",
                //host: "http://localhost:8080",
                //host: "https://logoregi-backend-768850626313.asia-northeast1.run.app",
                host: hostUrl, // configから動的に取得、空の場合はlocalhostを使用
                networkProtocol: .connect,
                codec: ProtoCodec()
            )
        )
    }
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
private enum CashierAdapterKey: DependencyKey {
    static let liveValue: any CashierAdapter = StarXCashierAdapter()
}
//private enum CustomerDisplayServiceKey: DependencyKey {
//    static let liveValue: any CustomerDisplayService = SwifterCustomerDisplayService()
//}
private enum DrawerTestKey: DependencyKey { // ContainerWithNavBarでドロア解放を行うためのKey
    static let liveValue = DrawerTest()
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
    var cashierAdapter: any CashierAdapter {
        get { self[CashierAdapterKey.self] }
        set { self[CashierAdapterKey.self] = newValue }
    }
    public var hostUrl: String {
        get { self[HostUrlKey.self] }
        set { self[HostUrlKey.self] = newValue }
    }
//    var customerDisplay: any CustomerDisplayService {
//        get {self[CustomerDisplayServiceKey.self] }
//        set {self[CustomerDisplayServiceKey.self] = newValue }
//    }

    // ContainerWithNavBarでドロア解放を行うために実装
    // NavBar用のFeatureを作ると複雑化して可読性が下がるため、DIして対応
    public var drawerTest: DrawerTest {
        get { self[DrawerTestKey.self] }
        set { self[DrawerTestKey.self] = newValue }
    }
}
