import SwiftUI

enum ClausiusClapeyronEstimatorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .clausiusClapeyronEstimator,
            title: "Clausius–Clapeyron Estimator",
            subtitle: "Estimate saturation pressure from a reference state",
            category: .thermodynamics,
            symbolName: "arrow.up.right.circle",
            keywords: [
                "Clausius Clapeyron",
                "vapor pressure",
                "latent heat",
                "saturation curve",
                "phase equilibrium"
            ]
        ),
        destination: {
            ClausiusClapeyronEstimatorView()
        }
    )
}
