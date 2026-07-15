import SwiftUI

enum LiquidPhaseDiffusivityModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .liquidPhaseDiffusivity,
            title:
                "Liquid-Phase Diffusivity",
            subtitle:
                "Scale dilute-solution diffusivity with temperature and viscosity",
            category: .massTransfer,
            symbolName: "drop.fill",
            keywords: [
                "liquid diffusivity",
                "stokes einstein",
                "viscosity",
                "temperature correction",
                "mass transfer"
            ]
        ),
        destination: {
            LiquidPhaseDiffusivityView()
        }
    )
}
