import SwiftUI

enum AnnualOperatingCostEstimateModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .annualOperatingCostEstimate,
            title: "Annual Operating Cost",
            subtitle: "Estimate annual manufacturing expenses",
            category: .processSafetyAndEconomics,
            symbolName: "dollarsign.circle.fill",
            keywords: [
                "annual operating cost",
                "manufacturing cost",
                "raw materials",
                "utilities",
                "unit production cost"
            ]
        ),
        destination: {
            AnnualOperatingCostEstimateView()
        }
    )
}
