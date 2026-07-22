import SwiftUI

enum GradientDescentOptimizationModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .gradientDescentOptimization,
            title: "Gradient Descent Optimization",
            subtitle: "Line-search optimization for supported two-variable objectives.",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: ["numerical methods", "differential equations", "gradient descent optimization"]
        ),
        destination: {
            GradientDescentOptimizationView()
        }
    )
}
