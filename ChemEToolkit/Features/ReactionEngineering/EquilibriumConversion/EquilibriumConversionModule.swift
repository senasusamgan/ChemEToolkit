import SwiftUI

enum EquilibriumConversionModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .equilibriumConversion,
            title: "Equilibrium Conversion",
            subtitle: "Determine equilibrium composition and reaction direction for A ⇌ B",
            category: .reactionEngineering,
            symbolName: "equal.circle.fill",
            keywords: [
                "equilibrium conversion",
                "equilibrium constant",
                "reaction quotient",
                "reversible reaction",
                "signed extent"
            ]
        ),
        destination: {
            EquilibriumConversionView()
        }
    )
}
