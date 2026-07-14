import SwiftUI

enum ReactorDesignModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .reactorDesign,
            title: "Reactor Design",
            subtitle: "Design Batch, CSTR and PFR reactors",
            category: .reactionEngineering,
            symbolName: "cylinder.split.1x2",
            keywords: [
                "reactor",
                "batch",
                "CSTR",
                "PFR",
                "conversion",
                "reaction time",
                "space time",
                "rate constant",
                "reaction engineering",
                "reactor volume"
            ],
            isFeatured: true
        ),
        destination: {
            ReactorView()
        }
    )
}
