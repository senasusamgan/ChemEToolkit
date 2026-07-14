import SwiftUI

enum ODESolverModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .odeSolver,
            title:
                "First-Order ODE Solver",
            subtitle:
                "Euler, Heun and Runge–Kutta methods",
            category: .numericalMethods,
            symbolName:
                "waveform.path.ecg",
            keywords: [
                "ordinary differential equation",
                "ODE",
                "Euler method",
                "Heun method",
                "Runge Kutta",
                "RK4",
                "initial value problem",
                "differential equation",
                "numerical methods",
                "dynamic model"
            ]
        ),
        destination: {
            ODESolverView()
        }
    )
}
