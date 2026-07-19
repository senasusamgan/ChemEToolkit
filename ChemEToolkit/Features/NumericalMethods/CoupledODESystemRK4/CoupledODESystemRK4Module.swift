import SwiftUI

enum CoupledODESystemRK4Module {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .coupledODESystemRK4,
            title: "Coupled ODE System RK4",
            subtitle: "Integrate a linear two-equation ODE system",
            category: .numericalMethods,
            symbolName: "point.3.connected.trianglepath.dotted",
            keywords: [
                "coupled ode system rk4",
                "numerical methods",
                "advanced solver"
            ]
        ),
        destination: {
            CoupledODESystemRK4View()
        }
    )
}
