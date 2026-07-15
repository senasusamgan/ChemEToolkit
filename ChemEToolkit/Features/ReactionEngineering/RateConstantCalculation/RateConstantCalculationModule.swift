import SwiftUI

enum RateConstantCalculationModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .rateConstantCalculation,
            title: "Rate Constant Calculation",
            subtitle: "Calculate k from rate, concentrations and kinetic orders",
            category: .reactionEngineering,
            symbolName: "k.square.fill",
            keywords: [
                "rate constant",
                "kinetic constant",
                "power law",
                "pseudo first order",
                "reaction rate"
            ]
        ),
        destination: {
            RateConstantCalculationView()
        }
    )
}
