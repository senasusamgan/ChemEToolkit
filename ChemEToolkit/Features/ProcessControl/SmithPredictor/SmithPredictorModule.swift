import SwiftUI

enum SmithPredictorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .smithPredictor,
            title: "Smith Predictor",
            subtitle: "Reconstruct a delay-free process estimate",
            category: .processControl,
            symbolName: "forward.end.alt.fill",
            keywords: [
                "Smith predictor",
                "dead time compensation",
                "FOPDT model",
                "model mismatch",
                "advanced control"
            ]
        ),
        destination: {
            SmithPredictorView()
        }
    )
}
