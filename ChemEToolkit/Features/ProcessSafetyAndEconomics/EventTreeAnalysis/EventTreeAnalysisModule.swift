import SwiftUI

enum EventTreeAnalysisModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .eventTreeAnalysis,
            title: "Event Tree Analysis",
            subtitle: "Calculate sequential outcome frequencies",
            category: .processSafetyAndEconomics,
            symbolName: "arrow.triangle.branch",
            keywords: [
                "event tree",
                "barrier success",
                "outcome frequency",
                "initiating event",
                "risk analysis"
            ]
        ),
        destination: {
            EventTreeAnalysisView()
        }
    )
}
