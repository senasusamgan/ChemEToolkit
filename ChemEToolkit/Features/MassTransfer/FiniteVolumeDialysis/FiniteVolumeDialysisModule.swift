import SwiftUI

enum FiniteVolumeDialysisModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .finiteVolumeDialysis,
            title:
                "Finite-Volume Dialysis",
            subtitle:
                "Calculate transient membrane transfer between two finite compartments",
            category: .massTransfer,
            symbolName:
                "rectangle.split.2x1.fill",
            keywords: [
                "dialysis",
                "membrane diffusion",
                "finite volume",
                "transient mass transfer",
                "two compartments",
                "equilibration"
            ]
        ),
        destination: {
            FiniteVolumeDialysisView()
        }
    )
}
