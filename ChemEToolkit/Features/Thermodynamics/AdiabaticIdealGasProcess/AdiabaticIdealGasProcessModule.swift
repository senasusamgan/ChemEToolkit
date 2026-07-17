import SwiftUI

enum AdiabaticIdealGasProcessModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .adiabaticIdealGasProcess,
            title: "Adiabatic Ideal-Gas Process",
            subtitle: "Calculate reversible adiabatic state change",
            category: .thermodynamics,
            symbolName: "arrow.up.right.circle.fill",
            keywords: [
                "adiabatic process",
                "isentropic relation",
                "ideal gas",
                "compression",
                "expansion"
            ]
        ),
        destination: {
            AdiabaticIdealGasProcessView()
        }
    )
}
