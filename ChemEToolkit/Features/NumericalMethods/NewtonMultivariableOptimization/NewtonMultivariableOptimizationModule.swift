import SwiftUI

enum NewtonMultivariableOptimizationModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .newtonMultivariableOptimization,
            title: "Newton Multivariable Optimization",
            subtitle: "Hessian-based optimization for supported two-variable objectives.",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: ["numerical methods", "differential equations", "newton multivariable optimization"]
        ),
        destination: {
            NewtonMultivariableOptimizationView()
        }
    )
}
