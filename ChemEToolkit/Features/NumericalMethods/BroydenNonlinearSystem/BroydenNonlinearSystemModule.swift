import SwiftUI

enum BroydenNonlinearSystemModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .broydenNonlinearSystem,
            title: "Broyden Nonlinear System",
            subtitle: "Solve supported two-variable systems with a rank-one Jacobian update.",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: ["numerical methods", "solver", "broyden nonlinear system"]
        ),
        destination: {
            BroydenNonlinearSystemView()
        }
    )
}
