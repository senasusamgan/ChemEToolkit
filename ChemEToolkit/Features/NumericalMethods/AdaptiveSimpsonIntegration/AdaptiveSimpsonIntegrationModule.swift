import SwiftUI

enum AdaptiveSimpsonIntegrationModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .adaptiveSimpsonIntegration,
            title: "Adaptive Simpson Integration",
            subtitle: "Adaptive error-controlled integration for supported engineering functions.",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: ["numerical methods", "approximation", "adaptive simpson integration"]
        ),
        destination: {
            AdaptiveSimpsonIntegrationView()
        }
    )
}
