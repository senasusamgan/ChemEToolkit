import SwiftUI

enum SeriesParallelReactionsModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .seriesParallelReactions,
            title: "Series–Parallel Reactions",
            subtitle: "Track a desired intermediate with series and parallel losses",
            category: .reactionEngineering,
            symbolName: "point.3.connected.trianglepath.dotted",
            keywords: [
                "series parallel reactions",
                "reaction network",
                "intermediate yield",
                "byproduct",
                "first order"
            ]
        ),
        destination: {
            SeriesParallelReactionsView()
        }
    )
}
