import SwiftUI

enum MixtureDensityCalculatorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .mixtureDensityCalculator,
            title: "Mixture Density",
            subtitle: "Estimate additive-volume mixture density",
            category: .engineeringFundamentals,
            symbolName: "drop.fill",
            keywords: [
                "mixture density",
                "additive volume",
                "component density",
                "mass fraction",
                "liquid mixture"
            ]
        ),
        destination: {
            MixtureDensityCalculatorView()
        }
    )
}
