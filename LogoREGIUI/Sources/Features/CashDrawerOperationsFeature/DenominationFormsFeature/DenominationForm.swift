// 1行の金種入力フォーム
import SwiftUI
import LogoREGICore

struct DenominationForm: View {
    let denomination: Denomination
    let onUpdate: (Denomination) -> Void
    let onFocusChange: (Bool, Int) -> Void
    let index: Int
    
    var body: some View {
        HStack(alignment: .center){
            HStack(){
                Text("")
                Spacer()
                Text("\(denomination.amount)円")
                
            }
            .frame(maxWidth: 100)
            
            
            Spacer()
            Text("×")
                .padding(.trailing)
            TextField("0", value: Binding(
                get: { denomination.quantity },
                set: { newValue in
                    var updatedDenomination = denomination
                    updatedDenomination.setQuantity(newValue: newValue)
                    onUpdate(updatedDenomination)
                }
                    ), formatter: NumberFormatter())
                        .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification), perform: { obj in
                            if let textField = obj.object as? UITextField {
                                textField.selectAll(textField.text)
                                
                                // タグを設定してTextFieldを識別できるようにする
                                textField.tag = index
                                
                                // ソフトウェアキーボードを非表示にする - 高さゼロのUIViewを使用して制約問題を解決
                                let emptyInputView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 0))
                                emptyInputView.backgroundColor = .clear
                                textField.inputView = emptyInputView
                                textField.inputAccessoryView = nil
                                textField.reloadInputViews()
                                
                                // フォーカス状態を更新 - 最後に呼び出して重複を防止
                                onFocusChange(true, index)
                            }
                        })
                        .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidEndEditingNotification), perform: { _ in
                            // フォーカス状態を更新
                            onFocusChange(false, index)
                        })
                        .keyboardType(.numberPad) // 数字のみ入力可能に
                        .multilineTextAlignment(.trailing)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 180)
                    
                    
                    Text("=")
                    HStack(){
                        Spacer()
                        Text("¥\(denomination.total())")
                        
                        
                    }
                    .frame(maxWidth: 100)
                    .padding(.trailing)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 5)
                .font(.title3)
            }
        }
