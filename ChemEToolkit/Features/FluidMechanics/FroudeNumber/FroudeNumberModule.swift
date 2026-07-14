import SwiftUI

enum FroudeNumberModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .froudeNumber,
            title:
                "Froude Number & Flow Regime",
            subtitle:
                "Classify open-channel flow using the Froude number",
            category:
                .fluidMechanics,
            symbolName:
                "water.waves",
            keywords: [
                "Froude number",
                "subcritical flow",
                "critical flow",
                "supercritical flow",
                "hydraulic depth",
                "wave celerity",
                "open channel",
                "flow regime",
                "fluid mechanics"
            ]
        ),
        destination: {
            FroudeNumberView()
        }
    )
}
