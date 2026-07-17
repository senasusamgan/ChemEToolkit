import SwiftUI

enum FlammabilityMixtureLimitsModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .flammabilityMixtureLimits,
            title: "Flammability Mixture Limits",
            subtitle: "Estimate LFL and UFL for fuel mixtures",
            category: .processSafetyAndEconomics,
            symbolName: "flame.fill",
            keywords: [
                "flammability limits",
                "LFL",
                "UFL",
                "Le Chatelier rule",
                "fuel mixture"
            ]
        ),
        destination: {
            FlammabilityMixtureLimitsView()
        }
    )
}
