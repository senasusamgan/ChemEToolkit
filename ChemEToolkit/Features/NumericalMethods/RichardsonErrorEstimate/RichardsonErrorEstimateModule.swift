import SwiftUI

enum RichardsonErrorEstimateModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .richardsonErrorEstimate,
            title: "Richardson Error Estimate",
            subtitle: "Extrapolate a result and estimate discretization error",
            category: .numericalMethods,
            symbolName: "plus.forwardslash.minus",
            keywords: [
                "richardson error estimate",
                "numerical methods",
                "advanced solver"
            ]
        ),
        destination: {
            RichardsonErrorEstimateView()
        }
    )
}
