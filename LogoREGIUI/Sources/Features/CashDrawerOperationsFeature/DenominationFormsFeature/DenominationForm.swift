// 1行の金種入力フォーム
import SwiftUI
import LogoREGICore

struct DenominationForm: View {
    let denomination: Denomination
    let onUpdate: (Denomination) -> Void
    let onFocusChange: (Bool, Int) -> Void
    let onRegisterTextField: (UITextField) -> Void
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
            NumericTextField(
                value: Binding(
                    get: { denomination.quantity },
                    set: { newValue in
                        var updatedDenomination = denomination
                        updatedDenomination.setQuantity(newValue: newValue)
                        onUpdate(updatedDenomination)
                    }
                ),
                index: index,
                onFocusChange: { isFocused in
                    onFocusChange(isFocused, index)
                },
                onRegisterTextField: onRegisterTextField
            )
            .frame(maxWidth: 180)
            .multilineTextAlignment(.trailing)
                    
                    
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
