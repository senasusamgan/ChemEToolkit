import SwiftUI

enum CatalystDeactivationKineticsModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .catalystDeactivationKinetics,
            title: "Catalyst Deactivation Kinetics",
            subtitle: "Evaluate power-law catalyst activity loss and lifetime",
            category: .reactionEngineering,
            symbolName: "chart.line.downtrend.xyaxis",
            keywords: [
                "catalyst deactivation",
                "activity decay",
                "deactivation order",
                "catalyst lifetime",
                "half life"
            ]
        ),
        destination: {
            CatalystDeactivationKineticsView()
        }
    )
}
