import SwiftUI

enum CrankNicolsonHeatEquationModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .crankNicolsonHeatEquation,
            title: "Crank-Nicolson Heat Equation",
            subtitle: "Implicit finite-difference transient conduction in a one-dimensional slab.",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: ["numerical methods", "differential equations", "crank-nicolson heat equation"]
        ),
        destination: {
            CrankNicolsonHeatEquationView()
        }
    )
}
