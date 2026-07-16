import SwiftUI

enum InverseLaplaceTransformHelperModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .inverseLaplaceTransformHelper,
            title: "Inverse Laplace Transform",
            subtitle: "Convert common transform forms into time-domain responses",
            category: .processControl,
            symbolName: "arrow.uturn.backward",
            keywords: [
                "inverse Laplace",
                "time response",
                "first order step",
                "sine cosine",
                "shifted pole"
            ]
        ),
        destination: { InverseLaplaceTransformHelperView() }
    )
}
