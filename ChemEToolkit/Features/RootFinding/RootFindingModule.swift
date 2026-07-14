import SwiftUI

enum RootFindingModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .rootFinding,
            title: "Polynomial Root Finding",
            subtitle:
                "Bisection, Newton–Raphson and Secant methods",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: [
                "root finding",
                "root",
                "zero",
                "polynomial",
                "bisection",
                "Newton Raphson",
                "Newton method",
                "secant",
                "nonlinear equation",
                "numerical methods",
                "convergence"
            ]
        ),
        destination: {
            RootFindingView()
        }
    )
}
