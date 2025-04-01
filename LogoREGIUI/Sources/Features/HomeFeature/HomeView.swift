import SwiftUI

struct HomeView: View {
    var body: some View {
        ContainerWithNavBar {
            // アクセントヘアライン
            // LogoREGI・ブランドカラー
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color(red: 0.44, green: 0.25, blue: 0.25), location: 0.00),
                            .init(color: Color(red: 0.26, green: 0.1, blue: 0.1), location: 1.00),
                        ]),
                        startPoint: UnitPoint(x: -0.05, y: 0.5),
                        endPoint: UnitPoint(x: 1.02, y: 0.5)
                    )
                )
                .frame(height: 8)
                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 4)
                .shadow(color: .black.opacity(0.1), radius: 7.5, x: 0, y: 10)
            
            GeometryReader { geometry in
                HStack(alignment: .top, spacing: 15) {
                    // 左列
                    VStack(spacing: 15) {
                        HomeNavigationButton(
                            title: "注文入力・会計",
                            subTitle: "（イートイン管理対応）",
                            description: "POSレジ・ハンディ端末から注文を管理",
                            fgColor: Color(Color(red: 0.176, green: 0.216, blue: 0.282)),
                            bgColor: Color(.white),
                            width: geometry.size.width * (1/3),
                            height: geometry.size.height,
                            icon: "cart",
                            state: AppFeature.Path.State.orderEntry(OrderEntryFeature.State())
                        )
                    }
                    // 中央列
                    VStack(alignment: .leading, spacing: 15) {
                        HomeNavigationButton(
                            title: "レジ入金",
                            subTitle: "",
                            description: "レジ内の釣り銭を設定",
                            fgColor: Color(Color(red: 0.176, green: 0.216, blue: 0.282)),
                            bgColor: Color(.white),
                            width: geometry.size.width * (1/3),
                            height: geometry.size.height * (1/4),
                            icon: "dollarsign.circle",
                            state: AppFeature.Path.State.cashDrawerSetup(CashDrawerOperationsFeature.State())
                        )
                        HomeNavigationButton(
                            title: "レジ点検",
                            subTitle: "",
                            description: "レジ内の釣り銭を差分を確認",
                            fgColor: Color(Color(red: 0.176, green: 0.216, blue: 0.282)),
                            bgColor: Color(.white),
                            width: geometry.size.width * (1/3),
                            height: geometry.size.height * (1/4),
                            icon: "magnifyingglass.circle",
                            state: AppFeature.Path.State.cashDrawerInspection(CashDrawerOperationsFeature.State())
                        )
                        HomeNavigationButton(
                            title: "レジ精算",
                            subTitle: "",
                            description: "レジ内の釣り銭を差分を確認・保存",
                            fgColor: Color(Color(red: 0.176, green: 0.216, blue: 0.282)),
                            bgColor: Color(.white),
                            width: geometry.size.width * (1/3),
                            height: geometry.size.height * (1/4),
                            icon: "checkmark.circle",
                            state: AppFeature.Path.State.cashDrawerClosing(CashDrawerOperationsFeature.State())
                        )
                        HomeNavigationButton(
                            title: "レジ操作履歴",
                            subTitle: "",
                            description: "レジ開け・精算の記録一覧を表示",
                            fgColor: Color(Color(red: 0.176, green: 0.216, blue: 0.282)),
                            bgColor: Color(.white),
                            width: geometry.size.width * (1/3),
                            height: geometry.size.height * (1/4),
                            icon: "clock.arrow.circlepath",
                            state: AppFeature.Path.State.cashDrawerHistory(CashDrawerHistoryFeature.State())
                        )
                        HomeNavigationButton(
                            title: "レジ操作履歴",
                            subTitle: "",
                            description: "レジ入金・精算履歴を確認",
                            fgColor: Color(Color(red: 0.176, green: 0.216, blue: 0.282)),
                            bgColor: Color(.white),
                            width: geometry.size.width * (1/3),
                            height: geometry.size.height * (1/4),
                            icon: "list.bullet.clipboard",
                            state: AppFeature.Path.State.paymentList(PaymentListFeature.State())
                        )
                    }
                    // 右列
                    VStack(alignment: .leading, spacing: 15) {
                        HomeNavigationButton(
                            title: "売上・商品設定",
                            subTitle: "",
                            description: "システムの商品設定・取引履歴・売上を確認",
                            fgColor: Color(Color(red: 0.176, green: 0.216, blue: 0.282)),
                            bgColor: Color(.white),
                            width: geometry.size.width * (1/3),
                            height: geometry.size.height * (1/4),
                            icon: "chart.bar",
                            state: AppFeature.Path.State.ordersList(OrdersListFeature.State())
                        )
                        HomeNavigationButton(
                            title: "設定",
                            subTitle: "",
                            description: "レジ・プリンターの動作や表示をカスタマイズ",
                            fgColor: Color(Color(red: 0.176, green: 0.216, blue: 0.282)),
                            bgColor: Color(.white),
                            width: geometry.size.width * (1/3),
                            height: geometry.size.height * (1/4),
                            icon: "gearshape",
                            state: AppFeature.Path.State.settings(SettingsFeature.State())
                        )
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
            }
        }
        .navigationTitle("ホーム")
        .navigationBarBackButtonHidden()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    HomeView()
}
