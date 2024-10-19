import Foundation
import UIKit
import StarIO10

public struct StarXCashierAdapter: CashierAdapter {
    func printReceipt(receipt: OrderReceipt) async {
        guard let logo = UIImage(named: "logos") else {
            print("Failed to load logos.png")
            return;
        }
        
        let builder = StarXpandCommand.StarXpandCommandBuilder()
        _ = builder.addDocument(
            StarXpandCommand.DocumentBuilder()
                .addPrinter(
                    StarXpandCommand.PrinterBuilder()
                        .actionPrintImage(StarXpandCommand.Printer.ImageParameter(image: logo, width: 400))
                        .actionFeedLine(1)
                        .styleSecondPriorityCharacterEncoding(.japanese)
                        .styleBold(true)
                        .styleAlignment(.center)
                        .styleMagnification(StarXpandCommand.MagnificationParameter(width: 3, height: 3))
                        .actionPrintText("引換券\n")
                        .actionPrintText("\(receipt.callNumber)\n")
                        .actionCut(StarXpandCommand.Printer.CutType.partial)
                )
        )
        
        await run(commands: builder.getCommands())
    }
    
    func openCacher() async {
        let builder = StarXpandCommand.StarXpandCommandBuilder()
        _ = builder.addDocument(StarXpandCommand.DocumentBuilder.init()
                            .addDrawer(StarXpandCommand.DrawerBuilder()
                                .actionOpen(StarXpandCommand.Drawer.OpenParameter()
                                    .setChannel(.no1)
                                )
                            )
        )
        
        await run(commands: builder.getCommands())
    }

    private func getStarPrinter() -> StarPrinter {
        return StarPrinter(StarConnectionSettings(interfaceType: .bluetooth, identifier: StarConnectionSettings.FIRST_FOUND_DEVICE))
    }
    
    private func run(commands: String, retryCount: Int = 0) async {
        let printer = getStarPrinter()
        
        do {
            try await printer.open()
            defer {
                Task {
                    await printer.close()
                }
            }
            
            try await printer.print(command: commands)
        } catch let err {
            print("Print Error: \(err)")
            
            if(retryCount > 5) {
                print("[StarIO] Retry Over")
            } else {
                await run(commands: commands, retryCount: retryCount+1)
            }
        }
    }
}
