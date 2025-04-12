import SwiftUI
import UIKit

public struct UIKitSampleView: UIViewRepresentable {
    public let title: String
    
    public init(title: String) {
        self.title = title
    }
    
    public func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .systemBlue
        label.backgroundColor = .systemBackground
        label.layer.cornerRadius = 12
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.systemGray.cgColor
        label.clipsToBounds = true
        return label
    }
    
    public func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.text = title
    }
}
