import SwiftUI

enum PBRPressureDropEffectsModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .pbrPressureDropEffects,
            title: "PBR Pressure-Drop Effects",
            subtitle: "Estimate pressure loss and its effect on first-order conversion",
            category: .reactionEngineering,
            symbolName: "gauge.with.dots.needle.33percent",
            keywords: [
                "PBR pressure drop",
                "gas phase reactor",
                "pressure effect",
                "catalyst weight",
                "conversion penalty"
            ]
        ),
        destination: {
            PBRPressureDropEffectsView()
        }
    )
}
