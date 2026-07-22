import SwiftUI

enum NelderMeadOptimizationModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .nelderMeadOptimization,
            title: "Nelder–Mead Optimization",
            subtitle: "Derivative-free optimization of supported two-variable objectives.",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: ["numerical methods", "approximation", "nelder–mead optimization"]
        ),
        destination: {
            NelderMeadOptimizationView()
        }
    )
}
