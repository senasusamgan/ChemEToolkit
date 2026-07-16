import SwiftUI

enum BypassFractionEstimatorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .bypassFractionEstimator,
            title: "Bypass Fraction Estimator",
            subtitle: "Estimate immediate bypass from a step-tracer outlet jump",
            category: .reactionEngineering,
            symbolName: "arrow.triangle.branch",
            keywords: [
                "bypass fraction",
                "step tracer",
                "short circuiting",
                "RTD diagnostics",
                "nonideal flow"
            ]
        ),
        destination: {
            BypassFractionEstimatorView()
        }
    )
}
