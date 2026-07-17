import SwiftUI

enum BinaryMinimumRefluxModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .binaryMinimumReflux,
            title: "Binary Minimum Reflux",
            subtitle: "Estimate saturated-liquid-feed minimum reflux",
            category: .separationProcesses,
            symbolName: "arrow.uturn.down.circle.fill",
            keywords: [
                "minimum reflux",
                "McCabe Thiele",
                "feed pinch",
                "distillation",
                "relative volatility"
            ]
        ),
        destination: {
            BinaryMinimumRefluxView()
        }
    )
}
