import SwiftUI

enum FrictionFactorModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .frictionFactor,
            title:
                "Pipe Friction Factor",
            subtitle:
                "Calculate Darcy and Fanning friction factors",
            category:
                .fluidMechanics,
            symbolName:
                "line.3.horizontal.decrease.circle.fill",
            keywords: [
                "friction factor",
                "Darcy friction factor",
                "Fanning friction factor",
                "Colebrook White",
                "pipe roughness",
                "relative roughness",
                "laminar flow",
                "turbulent flow",
                "Reynolds number",
                "Moody chart",
                "pipe flow",
                "fluid mechanics"
            ]
        ),
        destination: {
            FrictionFactorView()
        }
    )
}
