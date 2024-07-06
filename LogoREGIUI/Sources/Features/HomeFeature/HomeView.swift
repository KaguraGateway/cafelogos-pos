import SwiftUI

struct HomeView: View {
    var body: some View {
        ContainerWithNavBar {
            Divider()
            GeometryReader { geometry in
                HStack(alignment: .top, spacing: 15) {
                    // 左列
                    VStack(spacing: 15) {
                        HomeNavigationButton(
                            title: "注文入力・会計",
                            subTitle: "（イートイン管理対応）",
                            description: "POSレジ・ハンディ端末から注文を管理",
                            fgColor: Color.primary,
                            bgColor: Color(.secondarySystemFill),
                            width: geometry.size.width * (1/3),
                            height: geometry.size.height,
                            state: AppFeature.Path.State.orderEntry(OrderEntryFeature.State())
                        )
                    }
                    // 右列
                    VStack(alignment: .leading, spacing: 15) {
                        HomeNavigationButton(
                            title: "点検",
                            subTitle: "",
                            description: "レジ内の釣り銭を差分を確認",
                            fgColor: Color.primary,
                            bgColor: Color(.secondarySystemFill),
                            width: geometry.size.width * (1/3),
                            height: geometry.size.height * (1/3),
                            state: AppFeature.Path.State.printerTest(PrinterTestFeature.State())
                        )
                        HomeNavigationButton(
                            title: "精算",
                            subTitle: "",
                            description: "レジ内の釣り銭を差分を確認・保存",
                            fgColor: Color.primary,
                            bgColor: Color(.secondarySystemFill),
                            width: geometry.size.width * (1/3),
                            height: geometry.size.height * (1/3),
                            state: AppFeature.Path.State.printerTest(PrinterTestFeature.State())
                        )
                        HomeNavigationButton(
                            title: "設定",
                            subTitle: "",
                            description: "レジ・プリンターの動作や表示をカスタマイズ",
                            fgColor: Color.primary,
                            bgColor: Color(.secondarySystemFill),
                            width: geometry.size.width * (1/3),
                            height: geometry.size.height * (1/3),
                            state: AppFeature.Path.State.printerTest(PrinterTestFeature.State())
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
