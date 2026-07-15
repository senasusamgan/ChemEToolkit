import SwiftUI

enum MembraneGasSeparationModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .membraneGasSeparation,
            title:
                "Membrane Gas Separation",
            subtitle:
                "Calculate binary permeation flux, purity, stage cut and recovery",
            category: .massTransfer,
            symbolName:
                "square.split.2x1.fill",
            keywords: [
                "membrane separation",
                "gas permeation",
                "permeance",
                "selectivity",
                "stage cut",
                "permeate purity"
            ]
        ),
        destination: {
            MembraneGasSeparationView()
        }
    )
}
