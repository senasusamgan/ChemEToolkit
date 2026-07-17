import SwiftUI

enum SafetyIntegrityLevelTargetModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .safetyIntegrityLevelTarget,
            title: "Safety Integrity Level Target",
            subtitle: "Screen low-demand SIF risk reduction",
            category: .processSafetyAndEconomics,
            symbolName: "shield.fill",
            keywords: [
                "SIL target",
                "safety integrity level",
                "SIF",
                "risk reduction factor",
                "probability of failure on demand"
            ]
        ),
        destination: {
            SafetyIntegrityLevelTargetView()
        }
    )
}
