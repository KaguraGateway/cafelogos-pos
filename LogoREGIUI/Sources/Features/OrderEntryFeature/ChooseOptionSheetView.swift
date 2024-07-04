import SwiftUI
import LogoREGICore

struct ChooseOptionSheetView: View {
    @Binding var selectProduct: ProductDto?
    var onTapCoffeeBrew: (ProductDto, Option) -> Void
    
    func getOptions(product: ProductDto) -> [Option] {
        if(product.coffeeHowToBrews == nil) {
            return [Option]()
        }
        return product.coffeeHowToBrews!.map {
            Option(id: $0.id, title: $0.name, description: "¥\($0.amount)")
        }
    }
    
    var body: some View {
        ChooseOptionSheet(productName: "ドリップ方法", options: getOptions(product: selectProduct!), onAction: { option in
            onTapCoffeeBrew(selectProduct!, option)
        })
    }
}
