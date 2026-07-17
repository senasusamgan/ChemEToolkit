import SwiftUI

enum PumpIsentropicEfficiencyModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .pumpIsentropicEfficiency,
            title: "Pump Isentropic Efficiency",
            subtitle: "Calculate incompressible pump work and power",
            category: .thermodynamics,
            symbolName: "drop.triangle.fill",
            keywords: [
                "pump efficiency",
                "isentropic efficiency",
                "specific volume",
                "pressure rise",
                "power input"
            ]
        ),
        destination: { PumpIsentropicEfficiencyView() }
    )
}
