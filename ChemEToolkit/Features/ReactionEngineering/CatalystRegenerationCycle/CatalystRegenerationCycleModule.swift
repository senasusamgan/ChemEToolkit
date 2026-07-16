import SwiftUI

enum CatalystRegenerationCycleModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .catalystRegenerationCycle,
            title: "Catalyst Regeneration Cycle",
            subtitle: "Track activity across repeated operation and regeneration cycles",
            category: .reactionEngineering,
            symbolName: "arrow.triangle.2.circlepath.circle.fill",
            keywords: [
                "catalyst regeneration",
                "activity recovery",
                "cycle analysis",
                "deactivation regeneration",
                "equivalent operating time"
            ]
        ),
        destination: {
            CatalystRegenerationCycleView()
        }
    )
}
