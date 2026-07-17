import SwiftUI

enum NozzleDiffuserEnergyBalanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .nozzleDiffuserEnergyBalance,
            title: "Nozzle–Diffuser Energy Balance",
            subtitle: "Calculate outlet velocity from enthalpy change",
            category: .thermodynamics,
            symbolName: "wind.circle.fill",
            keywords: [
                "nozzle",
                "diffuser",
                "outlet velocity",
                "enthalpy change",
                "steady flow energy"
            ]
        ),
        destination: { NozzleDiffuserEnergyBalanceView() }
    )
}
