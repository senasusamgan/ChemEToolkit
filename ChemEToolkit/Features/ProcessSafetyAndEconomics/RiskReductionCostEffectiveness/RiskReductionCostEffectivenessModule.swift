import SwiftUI

enum RiskReductionCostEffectivenessModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .riskReductionCostEffectiveness,
            title: "Risk Reduction Cost Effectiveness",
            subtitle: "Compare avoided loss with safety cost",
            category: .processSafetyAndEconomics,
            symbolName: "shield.righthalf.filled",
            keywords: [
                "risk reduction cost",
                "benefit cost ratio",
                "avoided loss",
                "safety investment",
                "risk reduction NPV"
            ]
        ),
        destination: {
            RiskReductionCostEffectivenessView()
        }
    )
}
