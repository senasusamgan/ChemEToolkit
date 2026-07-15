import SwiftUI

enum SteadyStateDiffusionModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .steadyStateDiffusion,
            title: "Steady-State Diffusion",
            subtitle: "Planar diffusion flux, rate, and concentration profile",
            category: .massTransfer,
            symbolName: "rectangle.split.3x1",
            keywords: ["steady state", "planar", "diffusion", "rate", "concentration"]
        ),
        destination: { SteadyStateDiffusionView() }
    )
}
