import SwiftUI

enum MassBalanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .massBalance,
            title: "Mass Balance",
            subtitle: "Solve steady-state material balances",
            category: .materialAndEnergyBalances,
            symbolName: "scale.3d",
            keywords: [
                "mass",
                "balance",
                "mixer",
                "inlet",
                "outlet",
                "flow rate",
                "composition",
                "material balance",
                "component balance"
            ],
            isFeatured: true
        ),
        destination: {
            MassBalanceView()
        }
    )
}
