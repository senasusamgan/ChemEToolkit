import SwiftUI

enum DensitySpecificGravityModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .densitySpecificGravity,
            title: "Density & Specific Gravity",
            subtitle: "Calculate basic material-density properties",
            category: .engineeringFundamentals,
            symbolName: "scalemass.fill",
            keywords: [
                "density",
                "specific gravity",
                "specific volume",
                "mass",
                "volume"
            ]
        ),
        destination: {
            DensitySpecificGravityView()
        }
    )
}
