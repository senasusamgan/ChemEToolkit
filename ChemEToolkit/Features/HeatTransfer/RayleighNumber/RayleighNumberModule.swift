import SwiftUI

enum RayleighNumberModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .rayleighNumber,
            title: "Rayleigh Number",
            subtitle:
                "Combine Grashof and Prandtl numbers for natural convection",
            category: .heatTransfer,
            symbolName: "wind.circle.fill",
            keywords: [
                "Rayleigh number",
                "Grashof number",
                "Prandtl number",
                "natural convection",
                "buoyancy",
                "dimensionless number",
                "convection correlation",
                "heat transfer"
            ]
        ),
        destination: {
            RayleighNumberView()
        }
    )
}
