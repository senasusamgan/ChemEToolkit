import SwiftUI

enum AdsorptionIsothermsModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .adsorptionIsotherms,
            title: "Adsorption Isotherms",
            subtitle:
                "Calculate Langmuir, Freundlich and linear equilibrium loading",
            category: .massTransfer,
            symbolName:
                "circle.grid.2x2.fill",
            keywords: [
                "adsorption",
                "isotherm",
                "langmuir",
                "freundlich",
                "equilibrium loading",
                "adsorbent"
            ]
        ),
        destination: {
            AdsorptionIsothermsView()
        }
    )
}
