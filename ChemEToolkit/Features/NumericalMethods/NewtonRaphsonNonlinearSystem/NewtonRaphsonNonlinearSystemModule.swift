import SwiftUI

enum NewtonRaphsonNonlinearSystemModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .newtonRaphsonNonlinearSystem,
            title: "Newton–Raphson Nonlinear System",
            subtitle: "Solve supported two-variable nonlinear systems with a numerical Jacobian.",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: ["numerical methods", "solver", "newton–raphson nonlinear system"]
        ),
        destination: {
            NewtonRaphsonNonlinearSystemView()
        }
    )
}
