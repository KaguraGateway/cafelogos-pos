import Foundation

protocol CashierAdapter {
    func printReceipt(receipt: OrderReceipt) async
    func openCacher() async
}
