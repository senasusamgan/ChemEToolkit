import SwiftUI

enum AdaptiveControlModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .adaptiveControl,
            title: "Adaptive Control",
            subtitle: "Apply a constrained adaptive-gain update",
            category: .processControl,
            symbolName: "arrow.triangle.2.circlepath",
            keywords: [
                "adaptive control",
                "gain adaptation",
                "gradient update",
                "tracking error",
                "self tuning control"
            ]
        ),
        destination: {
            AdaptiveControlView()
        }
    )
}
