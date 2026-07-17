import SwiftUI

enum EquivalentAnnualWorthModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .equivalentAnnualWorth,
            title: "Equivalent Annual Worth",
            subtitle: "Annualize project economic value",
            category: .processSafetyAndEconomics,
            symbolName: "calendar.badge.clock",
            keywords: [
                "equivalent annual worth",
                "annual worth",
                "capital recovery factor",
                "sinking fund factor",
                "economic comparison"
            ]
        ),
        destination: {
            EquivalentAnnualWorthView()
        }
    )
}
