import SwiftUI

enum VaporQualityFromEnthalpyModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .vaporQualityFromEnthalpy,
            title: "Vapor Quality from Enthalpy",
            subtitle: "Calculate two-phase quality from saturation enthalpies",
            category: .thermodynamics,
            symbolName: "cloud.fill",
            keywords: [
                "vapor quality",
                "steam quality",
                "saturated mixture",
                "enthalpy",
                "two phase"
            ]
        ),
        destination: {
            VaporQualityFromEnthalpyView()
        }
    )
}
