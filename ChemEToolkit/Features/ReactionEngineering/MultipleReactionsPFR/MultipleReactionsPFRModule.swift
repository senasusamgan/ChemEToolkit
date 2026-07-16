import SwiftUI

enum MultipleReactionsPFRModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .multipleReactionsPFR,
            title: "Multiple Reactions in a PFR",
            subtitle: "Size a PFR for consecutive first-order reactions A → B → C",
            category: .reactionEngineering,
            symbolName: "arrow.right.to.line.compact",
            keywords: [
                "multiple reactions PFR",
                "consecutive reactions",
                "intermediate yield",
                "selectivity",
                "A to B to C"
            ]
        ),
        destination: {
            MultipleReactionsPFRView()
        }
    )
}
