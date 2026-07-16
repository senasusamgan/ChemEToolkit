import SwiftUI

enum MultipleReactionsCSTRModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .multipleReactionsCSTR,
            title: "Multiple Reactions in a CSTR",
            subtitle: "Size a CSTR for consecutive first-order reactions A → B → C",
            category: .reactionEngineering,
            symbolName: "circle.grid.2x2.fill",
            keywords: [
                "multiple reactions CSTR",
                "consecutive reactions",
                "intermediate yield",
                "perfect mixing",
                "A to B to C"
            ]
        ),
        destination: {
            MultipleReactionsCSTRView()
        }
    )
}
