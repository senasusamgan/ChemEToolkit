import SwiftUI

enum ReversibleReactionsModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .reversibleReactions,
            title: "Reversible Reactions",
            subtitle: "Calculate equilibrium approach for a first-order A ⇌ B system",
            category: .reactionEngineering,
            symbolName: "arrow.left.arrow.right",
            keywords: [
                "reversible reaction",
                "equilibrium",
                "forward reverse kinetics",
                "first order",
                "batch reactor"
            ]
        ),
        destination: {
            ReversibleReactionsView()
        }
    )
}
