import SwiftUI

enum FoulingAnalysisModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .foulingAnalysis,
            title: "Fouling Analysis",
            subtitle:
                "Compare clean and fouled heat-transfer performance",
            category: .heatTransfer,
            symbolName:
                "exclamationmark.triangle.fill",
            keywords: [
                "fouling analysis",
                "fouling resistance",
                "clean overall coefficient",
                "fouled overall coefficient",
                "heat exchanger degradation",
                "performance loss",
                "thermal resistance"
            ]
        ),
        destination: {
            FoulingAnalysisView()
        }
    )
}
