import SwiftUI

enum StepResponseRTDAnalysisModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .stepResponseRTDAnalysis,
            title: "Step-Response RTD Analysis",
            subtitle: "Extract residence-time statistics and E intervals from F(t)",
            category: .reactionEngineering,
            symbolName: "chart.xyaxis.line",
            keywords: [
                "step response RTD",
                "F curve analysis",
                "mean residence time",
                "bypass fraction",
                "finite difference E curve"
            ]
        ),
        destination: {
            StepResponseRTDAnalysisView()
        }
    )
}
