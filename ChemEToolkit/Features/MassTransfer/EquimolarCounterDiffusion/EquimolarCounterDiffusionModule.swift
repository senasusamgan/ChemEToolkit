import SwiftUI

enum EquimolarCounterDiffusionModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .equimolarCounterDiffusion,
            title: "Equimolar Counter-Diffusion",
            subtitle: "Binary gas diffusion with equal and opposite component fluxes",
            category: .massTransfer,
            symbolName: "arrow.left.arrow.right",
            keywords: ["equimolar", "counter diffusion", "binary gas", "flux", "ideal gas"]
        ),
        destination: { EquimolarCounterDiffusionView() }
    )
}
