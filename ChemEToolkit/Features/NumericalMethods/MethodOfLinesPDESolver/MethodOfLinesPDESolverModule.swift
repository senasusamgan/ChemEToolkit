import SwiftUI

enum MethodOfLinesPDESolverModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .methodOfLinesPDESolver,
            title: "Method of Lines PDE Solver",
            subtitle: "Diffusion-reaction PDE solved by spatial discretization and RK4.",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: ["numerical methods", "method of lines", "PDE", "diffusion", "reaction"]
        ),
        destination: {
            MethodOfLinesPDESolverView()
        }
    )
}
