import SwiftUI

enum MembraneReactorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .membraneReactor,
            title: "Membrane Reactor",
            subtitle: "Evaluate reversible reaction enhancement by selective product removal",
            category: .reactionEngineering,
            symbolName: "rectangle.split.3x1.fill",
            keywords: [
                "membrane reactor",
                "reversible reaction",
                "selective product removal",
                "equilibrium shift",
                "PFR"
            ]
        ),
        destination: {
            MembraneReactorView()
        }
    )
}
