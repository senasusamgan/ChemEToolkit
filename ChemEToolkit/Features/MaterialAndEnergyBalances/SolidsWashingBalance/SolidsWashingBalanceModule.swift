import SwiftUI

enum SolidsWashingBalanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .solidsWashingBalance,
            title: "Solids Washing Balance",
            subtitle: "Calculate solute removal in one washing stage",
            category: .materialAndEnergyBalances,
            symbolName: "drop.circle",
            keywords: [
                "solids washing",
                "cake washing",
                "solute removal",
                "wash solvent",
                "retained liquid"
            ]
        ),
        destination: {
            SolidsWashingBalanceView()
        }
    )
}
