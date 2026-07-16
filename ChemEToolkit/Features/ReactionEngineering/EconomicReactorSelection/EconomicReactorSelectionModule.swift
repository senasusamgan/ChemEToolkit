import SwiftUI

enum EconomicReactorSelectionModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .economicReactorSelection,
            title: "Economic Reactor Selection",
            subtitle: "Compare annualized PFR and CSTR costs for a first-order target",
            category: .reactionEngineering,
            symbolName: "dollarsign.circle.fill",
            keywords: [
                "economic reactor selection",
                "annualized cost",
                "PFR CSTR economics",
                "capital cost",
                "operating cost"
            ]
        ),
        destination: {
            EconomicReactorSelectionView()
        }
    )
}
