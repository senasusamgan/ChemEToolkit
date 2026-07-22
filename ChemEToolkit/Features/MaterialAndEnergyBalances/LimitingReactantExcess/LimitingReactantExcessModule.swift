import SwiftUI

enum LimitingReactantExcessModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .limitingReactantExcess,
            title: "Limiting & Excess Reactant",
            subtitle: "Determine limiting reactant and percent excess",
            category: .materialAndEnergyBalances,
            symbolName: "scalemass.fill",
            keywords: [
                "limiting reactant",
                "excess reactant",
                "stoichiometry",
                "reaction extent",
                "percent excess"
            ]
        ),
        destination: {
            LimitingReactantExcessView()
        }
    )
}
