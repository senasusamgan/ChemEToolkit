import SwiftUI

enum ArrheniusThreePointFitModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .arrheniusThreePointFit,
            title: "Three-Point Arrhenius Fit",
            subtitle: "Estimate activation energy and A from three kinetic points",
            category: .reactionEngineering,
            symbolName: "chart.dots.scatter",
            keywords: [
                "Arrhenius plot",
                "linear regression",
                "activation energy",
                "pre-exponential factor",
                "kinetic fitting",
                "R squared"
            ]
        ),
        destination: {
            ArrheniusThreePointFitView()
        }
    )
}
