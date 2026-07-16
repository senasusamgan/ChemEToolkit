import SwiftUI

enum ClosedLoopFeedbackAnalysisModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .closedLoopFeedbackAnalysis,
            title: "Closed-Loop Feedback",
            subtitle: "Analyze tracking, sensitivity and disturbance transmission",
            category: .processControl,
            symbolName: "arrow.triangle.2.circlepath",
            keywords: [
                "closed loop feedback",
                "sensitivity",
                "complementary sensitivity",
                "loop gain",
                "disturbance rejection"
            ]
        ),
        destination: { ClosedLoopFeedbackAnalysisView() }
    )
}
