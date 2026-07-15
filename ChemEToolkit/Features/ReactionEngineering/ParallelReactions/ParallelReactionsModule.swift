import SwiftUI

enum ParallelReactionsModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .parallelReactions,
            title: "Parallel Reactions",
            subtitle: "Calculate yield and selectivity for competing first-order paths",
            category: .reactionEngineering,
            symbolName: "arrow.triangle.branch",
            keywords: [
                "parallel reactions",
                "competing reactions",
                "selectivity",
                "desired product",
                "first order"
            ]
        ),
        destination: {
            ParallelReactionsView()
        }
    )
}
