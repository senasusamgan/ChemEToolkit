import SwiftUI

enum ReactionPerformanceBalanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .reactionPerformanceBalance,
            title: "Conversion–Yield–Selectivity",
            subtitle: "Calculate reaction performance measures",
            category: .materialAndEnergyBalances,
            symbolName: "chart.bar.xaxis",
            keywords: [
                "conversion",
                "yield",
                "selectivity",
                "desired product",
                "reaction performance"
            ]
        ),
        destination: {
            ReactionPerformanceBalanceView()
        }
    )
}
