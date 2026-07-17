import SwiftUI

enum EconomicSensitivityAnalysisModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .economicSensitivityAnalysis,
            title: "Economic Sensitivity Analysis",
            subtitle: "Compare base and changed economic cases",
            category: .processSafetyAndEconomics,
            symbolName: "arrow.left.arrow.right",
            keywords: [
                "economic sensitivity",
                "scenario analysis",
                "NPV sensitivity",
                "CAPEX sensitivity",
                "OPEX sensitivity"
            ]
        ),
        destination: {
            EconomicSensitivityAnalysisView()
        }
    )
}
