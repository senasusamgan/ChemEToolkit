import SwiftUI

enum ThomasTridiagonalSolverModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .thomasTridiagonalSolver,
            title: "Thomas Tridiagonal Solver",
            subtitle: "Efficiently solve tridiagonal linear systems.",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: ["numerical methods", "solver", "thomas tridiagonal solver"]
        ),
        destination: {
            ThomasTridiagonalSolverView()
        }
    )
}
