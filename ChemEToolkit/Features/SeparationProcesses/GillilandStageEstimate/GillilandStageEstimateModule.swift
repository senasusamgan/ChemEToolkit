import SwiftUI

enum GillilandStageEstimateModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .gillilandStageEstimate,
            title: "Gilliland Stage Estimate",
            subtitle: "Estimate theoretical stages from reflux ratio",
            category: .separationProcesses,
            symbolName: "chart.line.uptrend.xyaxis",
            keywords: [
                "Gilliland correlation",
                "theoretical stages",
                "reflux ratio",
                "distillation design",
                "Eduljee"
            ]
        ),
        destination: {
            GillilandStageEstimateView()
        }
    )
}
