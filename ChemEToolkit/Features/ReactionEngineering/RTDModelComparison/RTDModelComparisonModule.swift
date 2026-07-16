import SwiftUI

enum RTDModelComparisonModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .rtdModelComparison,
            title: "RTD Model Comparison",
            subtitle: "Compare first-order PFR, tanks-in-series and CSTR conversion",
            category: .reactionEngineering,
            symbolName: "chart.bar.xaxis.ascending",
            keywords: [
                "RTD model comparison",
                "tanks in series",
                "PFR CSTR conversion",
                "Peclet number",
                "Damkohler number"
            ]
        ),
        destination: {
            RTDModelComparisonView()
        }
    )
}
