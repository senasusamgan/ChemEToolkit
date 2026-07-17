import SwiftUI

enum GasReliefValveSizingModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .gasReliefValveSizing,
            title: "Gas Relief Valve Sizing",
            subtitle: "Estimate ideal-gas relief area",
            category: .processSafetyAndEconomics,
            symbolName: "wind",
            keywords: [
                "gas relief valve",
                "pressure safety valve",
                "choked flow",
                "orifice area",
                "relief sizing"
            ]
        ),
        destination: {
            GasReliefValveSizingView()
        }
    )
}
