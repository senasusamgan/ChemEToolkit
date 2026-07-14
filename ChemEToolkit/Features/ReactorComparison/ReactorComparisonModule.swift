import SwiftUI

enum ReactorComparisonModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .reactorComparison,
            title: "Reactor Comparison",
            subtitle: "Compare ideal reactor performance",
            category: .reactionEngineering,
            symbolName: "chart.bar.xaxis",
            keywords: [
                "reactor comparison",
                "CSTR",
                "PFR",
                "space time",
                "volume",
                "conversion",
                "performance",
                "first order reactor"
            ]
        ),
        destination: {
            ReactorComparisonView()
        }
    )
}
