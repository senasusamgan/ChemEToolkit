import SwiftUI

enum LiquidLevelDynamicsModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .liquidLevelDynamics,
            title: "Liquid-Level Dynamics",
            subtitle: "Calculate single-tank response and overflow risk",
            category: .processControl,
            symbolName: "water.waves",
            keywords: [
                "liquid level dynamics",
                "tank level",
                "hydraulic resistance",
                "overflow risk",
                "first order process"
            ]
        ),
        destination: {
            LiquidLevelDynamicsView()
        }
    )
}
