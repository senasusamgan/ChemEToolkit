import SwiftUI

enum InternalModelControlAnalysisModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .internalModelControlAnalysis,
            title: "Internal Model Control",
            subtitle: "Analyze IMC filtering and model mismatch",
            category: .processControl,
            symbolName: "gearshape.2.fill",
            keywords: [
                "Internal Model Control",
                "IMC filter",
                "inverse model",
                "robustness",
                "model mismatch"
            ]
        ),
        destination: {
            InternalModelControlAnalysisView()
        }
    )
}
