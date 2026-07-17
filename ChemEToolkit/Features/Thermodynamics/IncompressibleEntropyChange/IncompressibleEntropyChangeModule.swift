import SwiftUI

enum IncompressibleEntropyChangeModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .incompressibleEntropyChange,
            title: "Incompressible Entropy Change",
            subtitle: "Calculate entropy change for liquids and solids",
            category: .thermodynamics,
            symbolName: "drop.degreesign.fill",
            keywords: [
                "incompressible entropy",
                "liquid entropy",
                "solid entropy",
                "temperature ratio",
                "second law"
            ]
        ),
        destination: {
            IncompressibleEntropyChangeView()
        }
    )
}
