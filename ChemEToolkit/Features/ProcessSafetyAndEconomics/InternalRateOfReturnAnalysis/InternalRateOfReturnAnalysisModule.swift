import SwiftUI

enum InternalRateOfReturnAnalysisModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .internalRateOfReturnAnalysis,
            title: "Internal Rate of Return",
            subtitle: "Solve the project discount-rate root",
            category: .processSafetyAndEconomics,
            symbolName: "percent",
            keywords: [
                "internal rate of return",
                "IRR",
                "discount rate",
                "NPV root",
                "investment analysis"
            ]
        ),
        destination: {
            InternalRateOfReturnAnalysisView()
        }
    )
}
