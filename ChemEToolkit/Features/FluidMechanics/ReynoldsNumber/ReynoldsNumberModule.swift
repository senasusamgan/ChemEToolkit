import SwiftUI

enum ReynoldsNumberModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .reynoldsNumber,
            title:
                "Reynolds Number & Flow Regime",
            subtitle:
                "Calculate Reynolds number and classify internal pipe flow",
            category:
                .fluidMechanics,
            symbolName:
                "water.waves",
            keywords: [
                "Reynolds number",
                "flow regime",
                "fluid mechanics",
                "pipe flow",
                "internal flow",
                "laminar flow",
                "transitional flow",
                "turbulent flow",
                "dynamic viscosity",
                "kinematic viscosity",
                "density",
                "velocity",
                "diameter"
            ]
        ),
        destination: {
            ReynoldsNumberView()
        }
    )
}
