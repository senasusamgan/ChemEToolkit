import SwiftUI

enum BatchSettlingAreaEstimateModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .batchSettlingAreaEstimate,
            title: "Batch Settling Area Estimate",
            subtitle: "Estimate circular settler area and dimensions",
            category: .separationProcesses,
            symbolName: "circle.dotted.circle.fill",
            keywords: [
                "settling",
                "clarifier area",
                "settling velocity",
                "hydraulic loading",
                "tank diameter"
            ]
        ),
        destination: {
            BatchSettlingAreaEstimateView()
        }
    )
}
