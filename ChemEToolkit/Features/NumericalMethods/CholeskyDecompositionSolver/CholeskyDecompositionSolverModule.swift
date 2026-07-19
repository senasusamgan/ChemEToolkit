import SwiftUI

enum CholeskyDecompositionSolverModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .choleskyDecompositionSolver,
            title: "Cholesky Decomposition Solver",
            subtitle: "Solve symmetric positive-definite systems using Cholesky factorization.",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: ["numerical methods", "solver", "cholesky decomposition solver"]
        ),
        destination: {
            CholeskyDecompositionSolverView()
        }
    )
}
