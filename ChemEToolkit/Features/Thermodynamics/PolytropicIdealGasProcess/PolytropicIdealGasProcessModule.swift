import SwiftUI

enum PolytropicIdealGasProcessModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .polytropicIdealGasProcess,
            title: "Polytropic Ideal-Gas Process",
            subtitle: "Calculate PVⁿ state change and work",
            category: .thermodynamics,
            symbolName: "chart.xyaxis.line",
            keywords: [
                "polytropic process",
                "PVn",
                "boundary work",
                "compression",
                "expansion"
            ]
        ),
        destination: {
            PolytropicIdealGasProcessView()
        }
    )
}
