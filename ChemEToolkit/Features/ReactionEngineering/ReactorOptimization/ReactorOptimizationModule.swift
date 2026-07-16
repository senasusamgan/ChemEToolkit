import SwiftUI

enum ReactorOptimizationModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .reactorOptimization,
            title: "Reactor Optimization",
            subtitle: "Compare optimum PFR and CSTR operation for maximum intermediate yield",
            category: .reactionEngineering,
            symbolName: "target",
            keywords: [
                "reactor optimization",
                "maximum intermediate",
                "PFR CSTR comparison",
                "yield optimization",
                "consecutive reactions"
            ]
        ),
        destination: {
            ReactorOptimizationView()
        }
    )
}
