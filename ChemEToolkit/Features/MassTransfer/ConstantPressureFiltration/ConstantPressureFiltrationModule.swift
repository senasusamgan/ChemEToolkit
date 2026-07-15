import SwiftUI

enum ConstantPressureFiltrationModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .constantPressureFiltration,
            title:
                "Constant-Pressure Filtration",
            subtitle:
                "Calculate filtration time, cake resistance and filtrate rate",
            category: .massTransfer,
            symbolName:
                "line.3.horizontal.decrease.circle.fill",
            keywords: [
                "filtration",
                "constant pressure filtration",
                "cake resistance",
                "Ruth equation",
                "filter medium resistance",
                "filtrate flow"
            ]
        ),
        destination: {
            ConstantPressureFiltrationView()
        }
    )
}
