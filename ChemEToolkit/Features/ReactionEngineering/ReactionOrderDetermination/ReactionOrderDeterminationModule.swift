import SwiftUI

enum ReactionOrderDeterminationModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .reactionOrderDetermination,
            title: "Reaction Order Determination",
            subtitle: "Determine reaction order from two initial-rate experiments",
            category: .reactionEngineering,
            symbolName: "chart.xyaxis.line",
            keywords: [
                "reaction order",
                "initial rates",
                "kinetic data",
                "rate ratio",
                "experimental kinetics"
            ]
        ),
        destination: {
            ReactionOrderDeterminationView()
        }
    )
}
