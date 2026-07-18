import SwiftUI

enum PsychrometricAirEnthalpyModule {
    static let module =
        AppModule(
            metadata:
                ModuleMetadata(
                    id:
                        .psychrometricAirEnthalpy,
                    title:
                        "Psychrometric Air Enthalpy",
                    subtitle:
                        "Calculate humid-air enthalpy from temperature and humidity ratio",
                    category: .separationProcesses,
                    symbolName:
                        "thermometer.and.liquid.waves",
                    keywords: [
                        "psychrometric enthalpy",
                "humid air",
                "humidity ratio",
                "latent heat",
                "air conditioning"
                    ]
                ),
            destination: {
                PsychrometricAirEnthalpyView()
            }
        )
}
