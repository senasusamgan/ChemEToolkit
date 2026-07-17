import SwiftUI

enum SteadyFlowEnergyEquationModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .steadyFlowEnergyEquation,
            title: "Steady-Flow Energy Equation",
            subtitle: "Solve heat transfer including enthalpy, velocity and elevation",
            category: .thermodynamics,
            symbolName: "arrow.right.circle.fill",
            keywords: [
                "steady flow energy",
                "control volume",
                "enthalpy",
                "kinetic energy",
                "potential energy"
            ]
        ),
        destination: { SteadyFlowEnergyEquationView() }
    )
}
