import SwiftUI

enum PowerMethodEigenvalueModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .powerMethodEigenvalue,
            title: "Power Method Eigenvalue",
            subtitle: "Estimate the dominant eigenvalue of a 2×2 matrix",
            category: .numericalMethods,
            symbolName: "matrix.fill",
            keywords: [
                "power method eigenvalue",
                "numerical methods",
                "advanced solver"
            ]
        ),
        destination: {
            PowerMethodEigenvalueView()
        }
    )
}
