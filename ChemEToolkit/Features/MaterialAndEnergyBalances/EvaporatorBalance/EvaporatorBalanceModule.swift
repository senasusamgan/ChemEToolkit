import SwiftUI

enum EvaporatorBalanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .evaporatorBalance,
            title: "Evaporator Balance",
            subtitle: "Calculate product and evaporated-solvent flows",
            category: .materialAndEnergyBalances,
            symbolName: "flame.fill",
            keywords: [
                "evaporator balance",
                "nonvolatile solute",
                "solvent removal",
                "concentration",
                "material balance"
            ]
        ),
        destination: {
            EvaporatorBalanceView()
        }
    )
}
