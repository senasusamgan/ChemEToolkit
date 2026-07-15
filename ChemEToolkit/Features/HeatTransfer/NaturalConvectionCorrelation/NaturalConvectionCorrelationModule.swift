import SwiftUI

enum NaturalConvectionCorrelationModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .naturalConvectionCorrelation,
            title: "Natural Convection Correlations",
            subtitle:
                "Estimate natural-convection Nusselt number and coefficient",
            category: .heatTransfer,
            symbolName: "wind.circle.fill",
            keywords: [
                "natural convection",
                "Churchill Chu",
                "vertical plate",
                "horizontal cylinder",
                "Rayleigh number",
                "Prandtl number",
                "Nusselt number"
            ]
        ),
        destination: {
            NaturalConvectionCorrelationView()
        }
    )
}
