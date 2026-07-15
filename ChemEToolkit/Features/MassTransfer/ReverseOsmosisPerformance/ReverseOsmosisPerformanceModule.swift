import SwiftUI

enum ReverseOsmosisPerformanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .reverseOsmosisPerformance,
            title: "Reverse Osmosis Performance",
            subtitle:
                "Calculate water flux, rejection, recovery and concentrate composition",
            category: .massTransfer,
            symbolName: "drop.triangle.fill",
            keywords: [
                "reverse osmosis",
                "RO",
                "water flux",
                "solute rejection",
                "osmotic pressure",
                "membrane recovery"
            ]
        ),
        destination: {
            ReverseOsmosisPerformanceView()
        }
    )
}
