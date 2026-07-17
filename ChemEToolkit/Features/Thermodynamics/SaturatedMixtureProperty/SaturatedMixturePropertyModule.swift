import SwiftUI

enum SaturatedMixturePropertyModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .saturatedMixtureProperty,
            title: "Saturated Mixture Property",
            subtitle: "Interpolate a two-phase property from vapor quality",
            category: .thermodynamics,
            symbolName: "slider.horizontal.3",
            keywords: [
                "saturated mixture",
                "property interpolation",
                "vapor quality",
                "steam tables",
                "two phase"
            ]
        ),
        destination: {
            SaturatedMixturePropertyView()
        }
    )
}
