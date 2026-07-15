import SwiftUI

enum ReactionRateCalculatorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .reactionRateCalculator,
            title: "Reaction Rate Calculator",
            subtitle: "Calculate power-law reaction and species rates",
            category: .reactionEngineering,
            symbolName: "speedometer",
            keywords: [
                "reaction rate",
                "rate law",
                "power law",
                "reaction order",
                "kinetics"
            ]
        ),
        destination: {
            ReactionRateCalculatorView()
        }
    )
}
