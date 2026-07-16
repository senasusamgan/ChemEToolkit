import SwiftUI

enum DeadVolumeEstimatorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .deadVolumeEstimator,
            title: "Dead Volume Estimator",
            subtitle: "Estimate inaccessible reactor volume from measured residence time",
            category: .reactionEngineering,
            symbolName: "cube.transparent.fill",
            keywords: [
                "dead volume",
                "active volume",
                "mean residence time",
                "RTD diagnostics",
                "nonideal reactor"
            ]
        ),
        destination: {
            DeadVolumeEstimatorView()
        }
    )
}
