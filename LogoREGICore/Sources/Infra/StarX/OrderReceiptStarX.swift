//
//  OrderReceiptStarX.swift
//  cafelogos-pos
//
//  Created by ygates on 2023/10/11.
//

import Foundation
import UIKit
import StarIO10

public struct OrderReceiptStarX: OrderReceiptService {
    func printReceipt(receipt: OrderReceipt) -> String {
        guard let logo = UIImage(named: "logos") else {
            print("Failed to load logos.png")
            return "";
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
        
        return builder.getCommands()
    }
    
    func openCacher() -> String {
        let builder = StarXpandCommand.StarXpandCommandBuilder()
        _ = builder.addDocument(StarXpandCommand.DocumentBuilder.init()
                            .addDrawer(StarXpandCommand.DrawerBuilder()
                                .actionOpen(StarXpandCommand.Drawer.OpenParameter()
                                    .setChannel(.no1)
                                )
                            )
        )

        return builder.getCommands()
    }
}
