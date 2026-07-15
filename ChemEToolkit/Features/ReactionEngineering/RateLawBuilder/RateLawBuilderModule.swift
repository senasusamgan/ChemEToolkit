import SwiftUI

enum RateLawBuilderModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .rateLawBuilder,
            title: "Rate-Law Builder",
            subtitle: "Build kinetic, stoichiometric and rate-constant expressions",
            category: .reactionEngineering,
            symbolName: "function",
            keywords: [
                "rate law builder",
                "reaction order",
                "stoichiometric rate",
                "elementary reaction",
                "kinetic expression"
            ]
        ),
        destination: {
            RateLawBuilderView()
        }
    )
}
