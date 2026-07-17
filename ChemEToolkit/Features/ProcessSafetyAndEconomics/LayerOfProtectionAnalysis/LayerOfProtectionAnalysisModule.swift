import SwiftUI

enum LayerOfProtectionAnalysisModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .layerOfProtectionAnalysis,
            title: "Layer of Protection Analysis",
            subtitle: "Screen scenario frequency and IPL credit",
            category: .processSafetyAndEconomics,
            symbolName: "square.stack.3d.up.fill",
            keywords: [
                "LOPA",
                "independent protection layer",
                "probability of failure on demand",
                "risk reduction factor",
                "scenario frequency"
            ]
        ),
        destination: {
            LayerOfProtectionAnalysisView()
        }
    )
}
