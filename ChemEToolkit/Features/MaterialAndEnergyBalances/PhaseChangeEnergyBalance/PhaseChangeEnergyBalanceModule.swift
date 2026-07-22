import SwiftUI

enum PhaseChangeEnergyBalanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .phaseChangeEnergyBalance,
            title: "Phase-Change Energy Balance",
            subtitle: "Calculate latent duty for partial phase change",
            category: .materialAndEnergyBalances,
            symbolName: "cloud.sun.rain.fill",
            keywords: [
                "latent heat",
                "phase change",
                "vaporization",
                "condensation",
                "energy balance"
            ]
        ),
        destination: {
            PhaseChangeEnergyBalanceView()
        }
    )
}
