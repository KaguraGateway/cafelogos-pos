//
//
//

import Foundation
import Swifter

public class HTTPServerCustomerDisplayService: CustomerDisplayService {
    private let httpServer: HttpServer
    private var apiDataStore: CustomerDisplayAPIDataStore
    
    public init() {
        httpServer = HttpServer()
        apiDataStore = CustomerDisplayAPIDataStore()
        
        var bundlePath: String? = nil
        
        let path1 = Bundle.main.bundleURL.appendingPathComponent("Resources/CustomerDisplay").path
        if FileManager.default.fileExists(atPath: path1) {
            bundlePath = path1
            print("顧客モニター用静的ファイルパス(方法1): \(path1)")
        }
        
        let path2 = Bundle.main.bundleURL.appendingPathComponent("App/Resources/CustomerDisplay").path
        if bundlePath == nil && FileManager.default.fileExists(atPath: path2) {
            bundlePath = path2
            print("顧客モニター用静的ファイルパス(方法2): \(path2)")
        }
        
        if let bundlePath = bundlePath {
            httpServer["/"] = shareFilesFromDirectory(bundlePath)
        } else {
            print("静的ファイルが見つかりませんでした。埋め込みHTMLを使用します。")
            httpServer["/"] = { request in
                return .ok(.html(self.getEmbeddedHTML()))
            }
        }
        
        httpServer["/api/data"] = { request in
            do {
                let data = try JSONEncoder().encode(self.apiDataStore.currentData)
                return .ok(.data(data, contentType: "application/json"))
            } catch {
                print("APIデータエンコードエラー: \(error)")
                return .internalServerError
            }
        }
        
        do {
            try httpServer.start(8090)
            print("顧客モニター用サーバーを起動しました: http://localhost:8090")
        } catch {
            print("サーバー起動エラー: \(error)")
        }
    }
    
    public func updateOrder(orders: [Order]) {
        let items = orders.flatMap { order in
            order.cart.items.map { item in
                CustomerDisplayItem(
                    name: item.productName,
                    quantity: Int(item.quantity),
                    price: Int(item.productPrice),
                    brewMethod: item.coffeeHowToBrew?.name
                )
            }
        }
        
        apiDataStore.currentData.state = .entryList
        apiDataStore.currentData.items = items
        apiDataStore.currentData.totalAmount = Int(orders.reduce(0) { $0 + $1.totalAmount })
        apiDataStore.currentData.totalQuantity = Int(orders.reduce(0) { $0 + $1.cart.totalQuantity })
    }
    
    public func transitionPayment() {
        apiDataStore.currentData.state = .payment
    }
    
    public func transitionPaymentSuccess(payment: Payment) {
        apiDataStore.currentData.state = .thanks
        apiDataStore.currentData.receiveAmount = Int(payment.receiveAmount)
        apiDataStore.currentData.changeAmount = Int(payment.changeAmount)
    }
    
    private func getEmbeddedHTML() -> String {
        return """
        <!DOCTYPE html>
        <html lang="ja">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>カスタマーディスプレイ</title>
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
                    margin: 0;
                    padding: 0;
                    background-color: #f5f5f5;
                    color: #333;
                }
                .container {
                    max-width: 100%;
                    height: 100vh;
                    display: flex;
                    flex-direction: column;
                }
                .logo {
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    height: 100vh;
                    background-color: #f5f5f5;
                }
                .logo h1 {
                    font-size: 3rem;
                    color: #333;
                }
                .items-container {
                    flex: 1;
                    overflow-y: auto;
                    padding: 1rem;
                }
                .item {
                    display: flex;
                    justify-content: space-between;
                    padding: 0.5rem;
                    margin-bottom: 0.5rem;
                    background-color: white;
                    border-radius: 4px;
                    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
                }
                .item:nth-child(odd) {
                    background-color: #f9f9f9;
                }
                .total-bar {
                    background-color: #333;
                    color: white;
                    padding: 1rem;
                    display: flex;
                    justify-content: space-between;
                    font-size: 1.2rem;
                }
                .payment-info {
                    background-color: #4a4a4a;
                    color: white;
                    padding: 1rem;
                    display: flex;
                    justify-content: space-between;
                    font-size: 1.2rem;
                }
                .thanks {
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    align-items: center;
                    height: 100vh;
                    background-color: #f5f5f5;
                    text-align: center;
                }
                .thanks h1 {
                    font-size: 3rem;
                    margin-bottom: 2rem;
                }
                .thanks-info {
                    font-size: 1.5rem;
                    margin-bottom: 1rem;
                }
            </style>
        </head>
        <body>
            <div id="app" class="container">
                <!-- コンテンツはJavaScriptで動的に生成されます -->
            </div>

            <script>
                const StateType = {
                    logo: 0,
                    thanksUse: 1,
                    entryList: 2,
                    payment: 3,
                    thanks: 4,
                    ads: 5,
                    ads2: 6
                };

                async function fetchDisplayData() {
                    try {
                        const response = await fetch('/api/data');
                        if (!response.ok) {
                            throw new Error('Network response was not ok');
                        }
                        return await response.json();
                    } catch (error) {
                        console.error('Error fetching display data:', error);
                        return {
                            state: 0, // logo
                            items: [],
                            totalAmount: 0,
                            totalQuantity: 0,
                            receiveAmount: 0,
                            changeAmount: 0
                        };
                    }
                }

                function formatPrice(price) {
                    return new Intl.NumberFormat('ja-JP', { style: 'currency', currency: 'JPY' }).format(price);
                }

                function renderLogo() {
                    return `
                        <div class="logo">
                            <h1>Cafe Logos</h1>
                        </div>
                    `;
                }

                function renderEntryList(data) {
                    const itemsHtml = data.items.map((item, index) => `
                        <div class="item">
                            <div>
                                <span>${item.name}</span>
                                ${item.brewMethod ? `<small>(${item.brewMethod})</small>` : ''}
                            </div>
                            <div>
                                <span>${item.quantity}点</span>
                                <span>${formatPrice(item.price)}</span>
                            </div>
                        </div>
                    `).join('');

                    return `
                        <div class="items-container">
                            ${itemsHtml}
                        </div>
                        <div class="total-bar">
                            <span>合計: ${data.totalQuantity}点</span>
                            <span>${formatPrice(data.totalAmount)}</span>
                        </div>
                    `;
                }

                function renderPayment(data) {
                    const itemsHtml = data.items.map((item, index) => `
                        <div class="item">
                            <div>
                                <span>${item.name}</span>
                                ${item.brewMethod ? `<small>(${item.brewMethod})</small>` : ''}
                            </div>
                            <div>
                                <span>${item.quantity}点</span>
                                <span>${formatPrice(item.price)}</span>
                            </div>
                        </div>
                    `).join('');

                    return `
                        <div class="items-container">
                            ${itemsHtml}
                        </div>
                        <div class="total-bar">
                            <span>合計: ${data.totalQuantity}点</span>
                            <span>${formatPrice(data.totalAmount)}</span>
                        </div>
                        <div class="payment-info">
                            <span>お預かり</span>
                            <span>${formatPrice(data.receiveAmount)}</span>
                        </div>
                    `;
                }

                function renderThanks(data) {
                    return `
                        <div class="thanks">
                            <h1>ありがとうございました</h1>
                            <div class="thanks-info">合計: ${formatPrice(data.totalAmount)}</div>
                            <div class="thanks-info">お預かり: ${formatPrice(data.receiveAmount)}</div>
                            <div class="thanks-info">お釣り: ${formatPrice(data.changeAmount)}</div>
                        </div>
                    `;
                }

                function renderAds() {
                    return `
                        <div class="logo">
                            <h1>Cafe Logos</h1>
                            <p>本日もご来店ありがとうございます</p>
                        </div>
                    `;
                }

                async function updateDisplay() {
                    const appElement = document.getElementById('app');
                    const data = await fetchDisplayData();
                    
                    let content = '';
                    
                    switch (data.state) {
                        case StateType.logo:
                            content = renderLogo();
                            break;
                        case StateType.thanksUse:
                            content = renderAds();
                            break;
                        case StateType.entryList:
                            content = renderEntryList(data);
                            break;
                        case StateType.payment:
                            content = renderPayment(data);
                            break;
                        case StateType.thanks:
                            content = renderThanks(data);
                            break;
                        case StateType.ads:
                        case StateType.ads2:
                            content = renderAds();
                            break;
                        default:
                            content = renderLogo();
                    }
                    
                    appElement.innerHTML = content;
                }

                updateDisplay();
                
                setInterval(updateDisplay, 1000);
            </script>
        </body>
        </html>
        """
    }
}

fileprivate class CustomerDisplayAPIDataStore {
    var currentData: CustomerDisplayData = CustomerDisplayData(
        state: .logo,
        items: [],
        totalAmount: 0,
        totalQuantity: 0,
        receiveAmount: 0,
        changeAmount: 0
    )
}

fileprivate struct CustomerDisplayData: Codable {
    var state: CustomerDisplayState
    var items: [CustomerDisplayItem]
    var totalAmount: Int
    var totalQuantity: Int
    var receiveAmount: Int
    var changeAmount: Int
}

fileprivate struct CustomerDisplayItem: Codable {
    var name: String
    var quantity: Int
    var price: Int
    var brewMethod: String?
}

fileprivate enum CustomerDisplayState: Int, Codable {
    case logo = 0
    case thanksUse = 1
    case entryList = 2
    case payment = 3
    case thanks = 4
    case ads = 5
    case ads2 = 6
}
