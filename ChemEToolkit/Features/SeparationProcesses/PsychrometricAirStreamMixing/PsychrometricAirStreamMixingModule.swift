import SwiftUI

enum PsychrometricAirStreamMixingModule {
    static let module =
        AppModule(
            metadata:
                ModuleMetadata(
                    id:
                        .psychrometricAirStreamMixing,
                    title:
                        "Psychrometric Air-Stream Mixing",
                    subtitle:
                        "Mix two humid-air streams on a dry-air basis",
                    category: .separationProcesses,
                    symbolName:
                        "arrow.triangle.merge",
                    keywords: [
                        "air mixing",
                "psychrometrics",
                "humidity ratio",
                "mixed air temperature",
                "enthalpy balance"
                    ]
                ),
            destination: {
                PsychrometricAirStreamMixingView()
            }
        )
}
