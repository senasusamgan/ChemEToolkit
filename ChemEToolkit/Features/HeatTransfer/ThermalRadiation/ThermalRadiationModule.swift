import SwiftUI

enum ThermalRadiationModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .thermalRadiation,
            title:
                "Thermal Radiation",
            subtitle:
                "Calculate net radiation between a surface and large surroundings",
            category:
                .heatTransfer,
            symbolName:
                "sun.max.fill",
            keywords: [
                "thermal radiation",
                "Stefan Boltzmann law",
                "emissivity",
                "blackbody",
                "radiation heat transfer",
                "radiation heat flux",
                "surroundings temperature",
                "effective radiation coefficient"
            ]
        ),
        destination: {
            ThermalRadiationView()
        }
    )
}
