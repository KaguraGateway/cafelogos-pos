//
//  PrinterDiscovery.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/12.
//

import UIKit
import StarIO10

class PrinterDiscovery: ObservableObject, StarDeviceDiscoveryManagerDelegate {
    public let onDidDiscovery: (StarPrinter) -> Void

    public init(onDidDiscovery: @escaping (StarPrinter) -> Void) {
        self.onDidDiscovery = onDidDiscovery
    }

    func start() {
        if let manager = try? StarDeviceDiscoveryManagerFactory.create(interfaceTypes: [.bluetooth]) {
            manager.delegate = self
            manager.discoveryTime = 10000
            
            do {
                try manager.startDiscovery()
            } catch let err {
                print("error: \(err)")
            }
        }
    }

    func manager(_ manager: StarDeviceDiscoveryManager, didFind printer: StarPrinter) {
        DispatchQueue.main.async {
            self.onDidDiscovery(printer)
        }
    }
    
    func managerDidFinishDiscovery(_ manager: StarIO10.StarDeviceDiscoveryManager) {
        DispatchQueue.main.async {
            print("did finish")
        }
    }
}
