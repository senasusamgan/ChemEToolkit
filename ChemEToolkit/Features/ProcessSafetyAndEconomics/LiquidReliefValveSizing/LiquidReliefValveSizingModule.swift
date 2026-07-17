import SwiftUI

enum LiquidReliefValveSizingModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .liquidReliefValveSizing,
            title: "Liquid Relief Valve Sizing",
            subtitle: "Estimate incompressible liquid relief area",
            category: .processSafetyAndEconomics,
            symbolName: "drop.triangle.fill",
            keywords: [
                "liquid relief valve",
                "pressure safety valve",
                "orifice sizing",
                "incompressible flow",
                "relief area"
            ]
        ),
        destination: {
            LiquidReliefValveSizingView()
        }
    )
}
