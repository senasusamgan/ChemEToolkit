import SwiftUI

enum LUDecompositionSolverModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .luDecompositionSolver,
            title: "LU Decomposition Solver",
            subtitle: "Solve square linear systems using partial-pivoted LU factorization.",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: ["numerical methods", "solver", "lu decomposition solver"]
        ),
        destination: {
            LUDecompositionSolverView()
        }
    )
}
