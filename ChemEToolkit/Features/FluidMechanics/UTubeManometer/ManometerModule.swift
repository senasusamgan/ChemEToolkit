import SwiftUI

enum ManometerModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .uTubeManometer,
            title:
                "U-Tube Manometer",
            subtitle:
                "Calculate pressure difference from liquid-column displacement",
            category:
                .fluidMechanics,
            symbolName:
                "gauge.medium",
            keywords: [
                "manometer",
                "U tube manometer",
                "differential manometer",
                "pressure difference",
                "liquid column",
                "mercury manometer",
                "hydrostatics",
                "fluid density",
                "fluid mechanics"
            ]
        ),
        destination: {
            ManometerView()
        }
    )
}
