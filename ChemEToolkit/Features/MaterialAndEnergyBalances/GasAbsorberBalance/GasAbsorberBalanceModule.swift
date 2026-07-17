import SwiftUI

enum GasAbsorberBalanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .gasAbsorberBalance,
            title: "Gas Absorber Balance",
            subtitle: "Calculate gas-solute removal",
            category: .materialAndEnergyBalances,
            symbolName: "arrow.down.to.line.compact",
            keywords: [
                "gas absorber",
                "solute removal",
                "inert gas balance",
                "absorption",
                "molar balance"
            ]
        ),
        destination: {
            GasAbsorberBalanceView()
        }
    )
}
