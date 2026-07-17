import SwiftUI

enum IdealGasMixturePropertiesModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .idealGasMixtureProperties,
            title: "Ideal-Gas Mixture Properties",
            subtitle: "Calculate mixture molecular weight and specific R",
            category: .thermodynamics,
            symbolName: "wind",
            keywords: [
                "ideal gas mixture",
                "mixture molecular weight",
                "specific gas constant",
                "mole fraction",
                "gas properties"
            ]
        ),
        destination: {
            IdealGasMixturePropertiesView()
        }
    )
}
