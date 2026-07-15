import SwiftUI

enum LevenspielPlotSizingModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .levenspielPlotSizing,
            title: "Levenspiel Plot Sizing",
            subtitle: "Estimate PFR and CSTR volumes from inverse-rate data",
            category: .reactionEngineering,
            symbolName: "chart.area.fill",
            keywords: [
                "Levenspiel plot",
                "PFR sizing",
                "CSTR sizing",
                "Simpson rule",
                "inverse reaction rate",
                "reactor volume"
            ]
        ),
        destination: {
            LevenspielPlotSizingView()
        }
    )
}
