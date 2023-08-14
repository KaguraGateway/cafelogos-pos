//
//  HomeView.swift
//  cafelogos-pos
//
//  Created by Owner on 2023/08/14.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 0) {
            // 全体
            HeaderView ()
            Divider()
            // mainStack
            HStack(alignment: .top, spacing: 20) {
                // 左列
                VStack(spacing: 20.0) {
                    LeftButton(title: "注文入力・会計", subtitle: "（イートイン管理なし）", description: "POSレジのみから注文を入力・管理する")
                    LeftButton(title: "注文入力・会計", subtitle: "（イートイン管理あり）", description: "POSレジ・ハンディ端末から注文を管理する")
                }
                // 右列
                VStack(spacing: 20.0) {
                    RightButton(title: "点検", subtitle: "", description: "")
                    RightButton(title: "精算", subtitle: "", description: "")


                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            Spacer()
        }
    }
}

// ヘッダーコンポーネント
struct HeaderView: View {
    var body: some View {
        ZStack {
            Text("ホーム")
                .fixedSize(horizontal: false, vertical: false)
                .font(.headline)
                .foregroundColor(.primary)
            HStack {
                Spacer()
                ZStack {
                    Text("料金表示：通信確立　サーバー：通信可能")
                        .padding(5)
                        .padding(.horizontal, 10)
                        .background {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(.blue, lineWidth: 1)
                                .background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color(.systemBackground)))
                        }
                        .foregroundColor(.blue)
                }
                .padding(.trailing)
            }
            .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
            .clipped()
        }
    }
}

// 左側ボタン、命名規則は特にない
struct LeftButton: View {
    var title: String
    var subtitle: String
    var description: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.system(.largeTitle, weight: .semibold))
                .lineLimit(0)
            Text(subtitle)
                .font(.title3)
                .lineLimit(2)
            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.top, 10)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .aspectRatio(1/1, contentMode: .fit)
        .clipped()
        .padding(.horizontal, 30)
        .padding(.vertical, 30)
        .background {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color(.systemFill))
        }
    }
}

// 右側ボタン
struct RightButton: View {
    var title: String
    var subtitle: String
    var description: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.system(.largeTitle, weight: .semibold))
                .lineLimit(0)
            Text(subtitle)
                .font(.title3)
                .lineLimit(2)
            Text(description)
                .font(.body)
                .lineLimit(2)
                .padding(.top, 10)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .aspectRatio(3/1, contentMode: .fit)
        .clipped()
        .frame(maxWidth: 310, maxHeight: .infinity, alignment: .center)
        .clipped()
        .padding(.horizontal, 30)
        .padding(.vertical, 30)
        .background {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color(.systemFill))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewInterfaceOrientation(.landscapeRight)
            .previewDevice("iPad Pro (11-inch) (4th generation)")
    }
}
