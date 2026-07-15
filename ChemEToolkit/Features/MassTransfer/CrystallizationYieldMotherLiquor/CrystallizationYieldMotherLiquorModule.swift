import SwiftUI

enum CrystallizationYieldMotherLiquorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .crystallizationYieldMotherLiquor,
            title:
                "Crystallization Yield & Mother Liquor",
            subtitle:
                "Calculate crystal recovery and equilibrium mother-liquor losses",
            category: .massTransfer,
            symbolName: "snowflake",
            keywords: [
                "crystallization",
                "crystal yield",
                "mother liquor",
                "solubility",
                "evaporative crystallization",
                "hydrate crystals"
            ]
        ),
        destination: {
            CrystallizationYieldMotherLiquorView()
        }
    )
}
