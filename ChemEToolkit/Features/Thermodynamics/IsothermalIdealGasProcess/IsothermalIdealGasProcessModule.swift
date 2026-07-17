import SwiftUI

enum IsothermalIdealGasProcessModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .isothermalIdealGasProcess,
            title: "Isothermal Ideal-Gas Process",
            subtitle: "Calculate reversible isothermal work and heat",
            category: .thermodynamics,
            symbolName: "thermometer.low",
            keywords: [
                "isothermal process",
                "ideal gas work",
                "reversible expansion",
                "compression",
                "thermodynamics"
            ]
        ),
        destination: {
            IsothermalIdealGasProcessView()
        }
    )
}
