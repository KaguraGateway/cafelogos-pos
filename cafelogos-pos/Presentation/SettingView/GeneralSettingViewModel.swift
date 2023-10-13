//
//  GeneralSettingViewModel.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/08.
//

import Foundation
import StarIO10

class GeneralSettingViewModel: ObservableObject, StarDeviceDiscoveryManagerDelegate {
    @Published private var config: Config
    @Published private var printer: StarPrinter? = nil
    
    public init() {
        self.config = GetConfig().Execute()
        self.discovery()
    }
    
    public var clientId: String {
        get {
            return self.config.clientId
        }
    }
    
    public var clientName: String {
        get {
            return self.config.clientName
        }
        set {
            self.config.clientName = newValue
            SaveConfig().Execute(config: config)
        }
    }
    
    func manager(_ manager: StarDeviceDiscoveryManager, didFind printer: StarPrinter) {
         DispatchQueue.main.async {
             manager.stopDiscovery()
             self.printer = printer
             print("find")
         }
     }
     
     func managerDidFinishDiscovery(_ manager: StarIO10.StarDeviceDiscoveryManager) {
         DispatchQueue.main.async {
             print("did finish")
         }
     }
     
     func discovery(){
         if let manager = try? StarDeviceDiscoveryManagerFactory.create(interfaceTypes: [.bluetooth]){
             manager.delegate = self
             manager.discoveryTime = 1000
             do{
                 try manager.startDiscovery()
             }
             catch{
                 print("error")
             }
         }
     }
    
    func openCacher() {
        Task {
            let command = OpenCacher().Execute()
            
            
            do {
                try await printer!.open()
                defer {
                    Task {
                        await printer!.close()
                    }
                }
                
                try await printer?.print(command: command)
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
    
    func printReceipt() {
        Task {
            do {
                let command = PrintReceipt().Execute(receipt: OrderReceipt(callNumber: "L-101"))
                
                try await printer!.open()
                defer {
                    Task {
                        await printer!.close()
                    }
                }
                
                try await printer?.print(command: command)
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
}
