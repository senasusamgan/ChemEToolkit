import SwiftUI

enum NumericalIntegrationModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .numericalIntegration,
            title: "Numerical Integration",
            subtitle:
                "Trapezoidal and Simpson’s 1/3 rules",
            category: .numericalMethods,
            symbolName: "function",
            keywords: [
                "numerical integration",
                "integration",
                "integral",
                "trapezoidal",
                "trapezium",
                "Simpson",
                "Simpson 1/3",
                "tabulated data",
                "data points",
                "area under curve",
                "reactor design"
            ]
        ),
        destination: {
            NumericalIntegrationView()
        }
    )
}
