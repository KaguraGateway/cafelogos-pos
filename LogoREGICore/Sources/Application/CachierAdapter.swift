import Foundation

protocol CashierAdapter {
    func printReceipt(receipt: OrderReceipt) async
    func printKitchenReceipt(orderReceipt: OrderReceipt, items: [ReceiptItem]) async
    func openCacher() async
}
