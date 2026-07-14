import SwiftUI

enum NumericalDifferentiationModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .numericalDifferentiation,
            title:
                "Numerical Differentiation",
            subtitle:
                "Forward, backward and central differences",
            category: .numericalMethods,
            symbolName: "function",
            keywords: [
                "numerical differentiation",
                "differentiation",
                "derivative",
                "finite difference",
                "forward difference",
                "backward difference",
                "central difference",
                "slope",
                "tabulated data",
                "data points"
            ]
        ),
        destination: {
            NumericalDifferentiationView()
        }
    )
}
