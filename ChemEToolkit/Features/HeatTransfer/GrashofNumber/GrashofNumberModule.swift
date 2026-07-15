import SwiftUI

enum GrashofNumberModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .grashofNumber,
            title: "Grashof Number",
            subtitle:
                "Compare buoyancy and viscous forces in natural convection",
            category: .heatTransfer,
            symbolName: "arrow.up.to.line",
            keywords: [
                "Grashof number",
                "natural convection",
                "buoyancy",
                "viscous force",
                "thermal expansion coefficient",
                "kinematic viscosity",
                "characteristic length",
                "dimensionless number"
            ]
        ),
        destination: {
            GrashofNumberView()
        }
    )
}
