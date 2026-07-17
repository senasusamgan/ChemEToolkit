import SwiftUI

enum PaybackAndROIAnalysisModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .paybackAndROIAnalysis,
            title: "Payback & ROI Analysis",
            subtitle: "Estimate payback and accounting return",
            category: .processSafetyAndEconomics,
            symbolName: "clock.fill",
            keywords: [
                "payback period",
                "return on investment",
                "ROI",
                "after tax cash flow",
                "accounting return"
            ]
        ),
        destination: {
            PaybackAndROIAnalysisView()
        }
    )
}
