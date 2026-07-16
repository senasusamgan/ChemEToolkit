import SwiftUI

enum FCurveGeneratorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .fCurveGenerator,
            title: "F-Curve Generator",
            subtitle: "Integrate E(t) into a cumulative residence-time distribution",
            category: .reactionEngineering,
            symbolName: "chart.line.uptrend.xyaxis",
            keywords: [
                "F curve",
                "cumulative RTD",
                "t10 t50 t90",
                "residence time quantile",
                "tracer"
            ]
        ),
        destination: {
            FCurveGeneratorView()
        }
    )
}
