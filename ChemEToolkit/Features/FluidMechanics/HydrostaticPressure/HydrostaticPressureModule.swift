import SwiftUI

enum HydrostaticPressureModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .hydrostaticPressure,
            title:
                "Hydrostatic Pressure",
            subtitle:
                "Calculate pressure at depth in a stationary fluid",
            category:
                .fluidMechanics,
            symbolName:
                "drop.circle.fill",
            keywords: [
                "hydrostatic pressure",
                "pressure at depth",
                "fluid column",
                "pressure head",
                "gauge pressure",
                "absolute pressure",
                "density",
                "static fluid",
                "fluid mechanics"
            ]
        ),
        destination: {
            HydrostaticPressureView()
        }
    )
}
