import SwiftUI

enum GoldenSectionOptimizationModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .goldenSectionOptimization,
            title: "Golden-Section Optimization",
            subtitle: "Minimize a quadratic objective on a bounded interval",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: [
                "golden-section optimization",
                "numerical methods",
                "advanced solver"
            ]
        ),
        destination: {
            GoldenSectionOptimizationView()
        }
    )
}
