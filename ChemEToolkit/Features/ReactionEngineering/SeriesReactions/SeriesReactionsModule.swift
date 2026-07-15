import SwiftUI

enum SeriesReactionsModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .seriesReactions,
            title: "Series Reactions",
            subtitle: "Track reactant, intermediate and final product in A → B → C",
            category: .reactionEngineering,
            symbolName: "arrow.right.arrow.right",
            keywords: [
                "series reactions",
                "consecutive reactions",
                "intermediate maximum",
                "first order",
                "batch reactor"
            ]
        ),
        destination: {
            SeriesReactionsView()
        }
    )
}
