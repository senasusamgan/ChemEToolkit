import SwiftUI

enum LifecycleCostAnalysisModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .lifecycleCostAnalysis,
            title: "Lifecycle Cost Analysis",
            subtitle: "Estimate discounted ownership cost",
            category: .processSafetyAndEconomics,
            symbolName: "calendar.badge.clock",
            keywords: [
                "lifecycle cost",
                "total cost of ownership",
                "replacement cost",
                "equivalent annual cost",
                "discounted cost"
            ]
        ),
        destination: {
            LifecycleCostAnalysisView()
        }
    )
}
