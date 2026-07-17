import SwiftUI

enum BreakEvenProductionAnalysisModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .breakEvenProductionAnalysis,
            title: "Break-Even Production",
            subtitle: "Calculate output required to cover annual cost",
            category: .processSafetyAndEconomics,
            symbolName: "chart.line.uptrend.xyaxis",
            keywords: [
                "break even production",
                "contribution margin",
                "margin of safety",
                "capacity utilization",
                "cost volume profit"
            ]
        ),
        destination: {
            BreakEvenProductionAnalysisView()
        }
    )
}
