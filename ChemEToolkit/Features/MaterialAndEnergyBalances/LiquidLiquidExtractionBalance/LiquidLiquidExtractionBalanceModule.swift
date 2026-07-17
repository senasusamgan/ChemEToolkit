import SwiftUI

enum LiquidLiquidExtractionBalanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .liquidLiquidExtractionBalance,
            title: "Liquid–Liquid Extraction Balance",
            subtitle: "Calculate single-stage solute extraction",
            category: .materialAndEnergyBalances,
            symbolName: "square.split.2x1.fill",
            keywords: [
                "liquid liquid extraction",
                "distribution coefficient",
                "raffinate",
                "extract",
                "solute balance"
            ]
        ),
        destination: {
            LiquidLiquidExtractionBalanceView()
        }
    )
}
