import SwiftUI

enum AntoineVaporPressureModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .antoineVaporPressure,
            title: "Antoine Vapor Pressure",
            subtitle: "Estimate saturation pressure from Antoine coefficients",
            category: .thermodynamics,
            symbolName: "gauge.with.dots.needle.67percent",
            keywords: [
                "Antoine equation",
                "vapor pressure",
                "saturation pressure",
                "boiling point",
                "pure component"
            ]
        ),
        destination: {
            AntoineVaporPressureView()
        }
    )
}
