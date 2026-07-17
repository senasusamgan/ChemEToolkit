import SwiftUI

enum AbsorptionStrippingFactorsModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .absorptionStrippingFactors,
            title: "Absorption & Stripping Factors",
            subtitle: "Calculate Kremser operating factors",
            category: .separationProcesses,
            symbolName: "arrow.up.and.down.text.horizontal",
            keywords: [
                "absorption factor",
                "stripping factor",
                "Kremser",
                "liquid gas ratio",
                "equilibrium slope"
            ]
        ),
        destination: {
            AbsorptionStrippingFactorsView()
        }
    )
}
