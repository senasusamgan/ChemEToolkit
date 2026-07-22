import SwiftUI

enum DiffusionThroughMembraneModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .diffusionThroughMembrane,
            title:
                "Diffusion Through a Membrane",
            subtitle:
                "Calculate membrane permeability, flux and transfer rate",
            category: .massTransfer,
            symbolName:
                "rectangle.portrait.fill",
            keywords: [
                "membrane diffusion",
                "permeability",
                "permeance",
                "partition coefficient",
                "solution diffusion",
                "membrane resistance"
            ]
        ),
        destination: {
            DiffusionThroughMembraneView()
        }
    )
}
