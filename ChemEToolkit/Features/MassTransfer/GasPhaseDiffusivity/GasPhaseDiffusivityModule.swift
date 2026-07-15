import SwiftUI

enum GasPhaseDiffusivityModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .gasPhaseDiffusivity,
            title: "Gas-Phase Diffusivity",
            subtitle:
                "Scale binary gas diffusivity with temperature and pressure",
            category: .massTransfer,
            symbolName: "cloud.fill",
            keywords: [
                "gas diffusivity",
                "binary diffusion",
                "temperature correction",
                "pressure correction",
                "mass transfer"
            ]
        ),
        destination: {
            GasPhaseDiffusivityView()
        }
    )
}
