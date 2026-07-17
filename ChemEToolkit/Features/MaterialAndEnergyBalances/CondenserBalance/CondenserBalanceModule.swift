import SwiftUI

enum CondenserBalanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .condenserBalance,
            title: "Condenser Balance",
            subtitle: "Calculate condensate and vent production",
            category: .materialAndEnergyBalances,
            symbolName: "cloud.rain.fill",
            keywords: [
                "condenser balance",
                "partial condensation",
                "noncondensable gas",
                "vent gas",
                "condensate"
            ]
        ),
        destination: {
            CondenserBalanceView()
        }
    )
}
