import SwiftUI

enum ConjugateGradientSolverModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .conjugateGradientSolver,
            title: "Conjugate Gradient Solver",
            subtitle: "Iteratively solve symmetric positive-definite linear systems.",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: ["numerical methods", "solver", "conjugate gradient solver"]
        ),
        destination: {
            ConjugateGradientSolverView()
        }
    )
}
