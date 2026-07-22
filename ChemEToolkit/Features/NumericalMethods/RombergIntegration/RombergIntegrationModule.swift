import SwiftUI

enum RombergIntegrationModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .rombergIntegration,
            title: "Romberg Integration",
            subtitle: "Richardson-extrapolated trapezoidal integration with a convergence table.",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: ["numerical methods", "approximation", "romberg integration"]
        ),
        destination: {
            RombergIntegrationView()
        }
    )
}
