import SwiftUI

enum AdiabaticMixingTemperatureModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .adiabaticMixingTemperature,
            title: "Adiabatic Mixing Temperature",
            subtitle: "Calculate two-stream mixing temperature",
            category: .materialAndEnergyBalances,
            symbolName: "arrow.triangle.merge",
            keywords: [
                "adiabatic mixing",
                "mixing temperature",
                "heat capacity rate",
                "energy balance",
                "two streams"
            ]
        ),
        destination: {
            AdiabaticMixingTemperatureView()
        }
    )
}
