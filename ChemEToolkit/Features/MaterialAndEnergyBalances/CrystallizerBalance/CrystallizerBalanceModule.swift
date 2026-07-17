import SwiftUI

enum CrystallizerBalanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .crystallizerBalance,
            title: "Crystallizer Balance",
            subtitle: "Calculate crystal yield and solute recovery",
            category: .materialAndEnergyBalances,
            symbolName: "snowflake",
            keywords: [
                "crystallizer balance",
                "crystal yield",
                "mother liquor",
                "solute recovery",
                "material balance"
            ]
        ),
        destination: {
            CrystallizerBalanceView()
        }
    )
}
