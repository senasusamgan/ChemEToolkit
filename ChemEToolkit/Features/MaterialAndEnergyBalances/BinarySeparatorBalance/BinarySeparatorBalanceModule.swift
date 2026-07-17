import SwiftUI

enum BinarySeparatorBalanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .binarySeparatorBalance,
            title: "Binary Separator Balance",
            subtitle: "Solve a two-product component balance",
            category: .materialAndEnergyBalances,
            symbolName: "arrow.triangle.pull",
            keywords: [
                "binary separator",
                "component balance",
                "product composition",
                "recovery",
                "mass balance"
            ]
        ),
        destination: {
            BinarySeparatorBalanceView()
        }
    )
}
