import SwiftUI
import UIKit

struct NumericTextField: UIViewRepresentable {
    @Binding var value: UInt64
    let index: Int
    let onFocusChange: (Bool) -> Void
    let onRegisterTextField: (UITextField) -> Void
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.keyboardType = .numberPad
        textField.textAlignment = .right
        textField.borderStyle = .roundedRect
        textField.text = "\(value)"
        textField.tag = index
        
        // ソフトウェアキーボードを非表示にする - 高さゼロのUIViewを使用して制約問題を解決
        let emptyInputView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 0))
        emptyInputView.backgroundColor = .clear
        textField.inputView = emptyInputView
        textField.inputAccessoryView = nil
        
        // TextFieldを直接登録
        onRegisterTextField(textField)
        
        return textField
    }
    
    func updateUIView(_ textField: UITextField, context: Context) {
        if textField.text != "\(value)" && !textField.isFirstResponder {
            textField.text = "\(value)"
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: NumericTextField
        
        init(_ parent: NumericTextField) {
            self.parent = parent
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            textField.selectAll(nil)
            parent.onFocusChange(true)
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            parent.onFocusChange(false)
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // 数字のみ許可
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
    }
}
