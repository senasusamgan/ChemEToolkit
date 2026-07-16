import SwiftUI

enum LaplaceTransformHelperModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .laplaceTransformHelper,
            title: "Laplace Transform Helper",
            subtitle: "Evaluate common one-sided Laplace-transform pairs",
            category: .processControl,
            symbolName: "function",
            keywords: [
                "Laplace transform",
                "constant",
                "ramp",
                "exponential",
                "sine cosine"
            ]
        ),
        destination: { LaplaceTransformHelperView() }
    )
}
