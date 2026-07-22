import SwiftUI

enum EffectiveDiffusivityModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .effectiveDiffusivity,
            title: "Effective Diffusivity",
            subtitle:
                "Calculate porous-medium molecular and Knudsen diffusivity",
            category: .massTransfer,
            symbolName:
                "circle.hexagongrid.fill",
            keywords: [
                "effective diffusivity",
                "porosity",
                "tortuosity",
                "constrictivity",
                "Knudsen diffusion",
                "Bosanquet"
            ]
        ),
        destination: {
            EffectiveDiffusivityView()
        }
    )
}
