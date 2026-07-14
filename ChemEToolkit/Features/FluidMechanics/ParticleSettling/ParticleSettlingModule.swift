import SwiftUI

enum ParticleSettlingModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .particleSettling,
            title:
                "Particle Settling — Stokes Law",
            subtitle:
                "Estimate particle terminal velocity and check the Stokes regime",
            category: .fluidMechanics,
            symbolName:
                "arrow.down.circle.fill",
            keywords: [
                "particle settling",
                "terminal velocity",
                "Stokes law",
                "particle Reynolds number",
                "sedimentation",
                "rising particle",
                "particle diameter",
                "dynamic viscosity",
                "fluid mechanics"
            ]
        ),
        destination: {
            ParticleSettlingView()
        }
    )
}
