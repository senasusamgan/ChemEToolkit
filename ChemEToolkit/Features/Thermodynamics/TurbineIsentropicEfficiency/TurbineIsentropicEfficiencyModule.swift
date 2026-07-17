import SwiftUI

enum TurbineIsentropicEfficiencyModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .turbineIsentropicEfficiency,
            title: "Turbine Isentropic Efficiency",
            subtitle: "Calculate turbine efficiency and power output",
            category: .thermodynamics,
            symbolName: "fanblades.fill",
            keywords: [
                "turbine efficiency",
                "isentropic efficiency",
                "power output",
                "enthalpy drop",
                "steady flow"
            ]
        ),
        destination: { TurbineIsentropicEfficiencyView() }
    )
}
