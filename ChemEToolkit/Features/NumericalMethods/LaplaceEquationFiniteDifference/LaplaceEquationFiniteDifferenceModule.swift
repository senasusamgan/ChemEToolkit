import SwiftUI

enum LaplaceEquationFiniteDifferenceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .laplaceEquationFiniteDifference,
            title: "Laplace Equation Finite Difference",
            subtitle: "Steady two-dimensional field solution on a rectangular grid.",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: ["numerical methods", "differential equations", "laplace equation finite difference"]
        ),
        destination: {
            LaplaceEquationFiniteDifferenceView()
        }
    )
}
