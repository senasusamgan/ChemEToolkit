import SwiftUI

enum LinearSystemModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .linearSystems,
            title: "Linear Systems Solver",
            subtitle:
                "Gaussian Elimination and Gauss–Seidel",
            category: .numericalMethods,
            symbolName:
                "square.grid.3x3.fill",
            keywords: [
                "linear systems",
                "linear equations",
                "matrix",
                "Gaussian elimination",
                "partial pivoting",
                "Gauss Seidel",
                "iterative method",
                "Ax equals b",
                "simultaneous equations",
                "numerical methods"
            ]
        ),
        destination: {
            LinearSystemView()
        }
    )
}
