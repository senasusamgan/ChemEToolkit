import SwiftUI

enum QRDecompositionSolverModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .qrDecompositionSolver,
            title: "QR Decomposition Solver",
            subtitle: "Solve full-rank square or overdetermined least-squares systems.",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: ["numerical methods", "solver", "qr decomposition solver"]
        ),
        destination: {
            QRDecompositionSolverView()
        }
    )
}
