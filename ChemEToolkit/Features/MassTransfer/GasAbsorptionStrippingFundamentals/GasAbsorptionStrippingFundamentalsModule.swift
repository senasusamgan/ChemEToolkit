import SwiftUI

enum GasAbsorptionStrippingFundamentalsModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .gasAbsorptionStrippingFundamentals,
            title: "Gas Absorption & Stripping Fundamentals",
            subtitle: "Solve countercurrent balances, operating factors and limiting flow",
            category: .massTransfer,
            symbolName: "arrow.down.to.line",
            keywords: [
                "gas absorption", "stripping", "operating line",
                "minimum solvent", "absorption factor", "stripping factor"
            ]
        ),
        destination: { GasAbsorptionStrippingFundamentalsView() }
    )
}
