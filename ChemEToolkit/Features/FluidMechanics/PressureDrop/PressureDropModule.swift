import SwiftUI

enum PressureDropModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .pressureDrop,
            title:
                "Darcy–Weisbach Pressure Drop",
            subtitle:
                "Calculate major head and pressure loss through a straight pipe",
            category:
                .fluidMechanics,
            symbolName:
                "drop.fill",
            keywords: [
                "pressure drop",
                "head loss",
                "Darcy Weisbach",
                "major loss",
                "pipe friction",
                "pipe length",
                "pressure gradient",
                "friction factor",
                "Reynolds number",
                "dynamic viscosity",
                "pipe roughness",
                "fluid mechanics"
            ]
        ),
        destination: {
            PressureDropView()
        }
    )
}
