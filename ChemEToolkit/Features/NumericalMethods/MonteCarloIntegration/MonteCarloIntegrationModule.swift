import SwiftUI

enum MonteCarloIntegrationModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .monteCarloIntegration,
            title: "Monte Carlo Integration",
            subtitle: "Seeded stochastic integration with a standard-error estimate.",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: ["numerical methods", "approximation", "monte carlo integration"]
        ),
        destination: {
            MonteCarloIntegrationView()
        }
    )
}
