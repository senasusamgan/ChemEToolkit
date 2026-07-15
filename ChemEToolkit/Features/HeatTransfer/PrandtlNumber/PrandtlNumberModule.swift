import SwiftUI

enum PrandtlNumberModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .prandtlNumber,
            title: "Prandtl Number",
            subtitle:
                "Compare momentum and thermal diffusivity",
            category: .heatTransfer,
            symbolName: "waveform.path.ecg",
            keywords: [
                "Prandtl number",
                "dimensionless number",
                "dynamic viscosity",
                "specific heat",
                "thermal conductivity",
                "momentum diffusivity",
                "thermal diffusivity",
                "convection"
            ]
        ),
        destination: {
            PrandtlNumberView()
        }
    )
}
