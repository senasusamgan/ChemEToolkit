import SwiftUI

enum TotalCapitalInvestmentEstimateModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .totalCapitalInvestmentEstimate,
            title: "Total Capital Investment",
            subtitle: "Combine plant and working-capital costs",
            category: .processSafetyAndEconomics,
            symbolName: "dollarsign.circle.fill",
            keywords: [
                "total capital investment",
                "fixed capital investment",
                "direct plant cost",
                "contingency",
                "working capital"
            ]
        ),
        destination: {
            TotalCapitalInvestmentEstimateView()
        }
    )
}
