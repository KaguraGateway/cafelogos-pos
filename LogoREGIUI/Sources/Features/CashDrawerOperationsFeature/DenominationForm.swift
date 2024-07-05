// 1行の金種入力フォーム
import SwiftUI
import LogoREGICore

struct DenominationForm: View {
    @Binding var denomination: Denomination
    
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
            TextField("0", value: Binding(get: { denomination.quantity }, set: { denomination.setQuantity(newValue: $0) }), formatter: NumberFormatter())
                .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification), perform: { obj in
                    if let textField = obj.object as? UITextField {
                        textField.selectAll(textField.text)
                        
                    }
                })
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
