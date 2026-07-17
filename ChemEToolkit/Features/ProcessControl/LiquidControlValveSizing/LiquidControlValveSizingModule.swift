import SwiftUI

enum LiquidControlValveSizingModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .liquidControlValveSizing,
            title: "Liquid Control Valve Sizing",
            subtitle: "Calculate required Kv and valve capacity",
            category: .processControl,
            symbolName: "drop.fill",
            keywords: [
                "control valve sizing",
                "Kv",
                "Cv",
                "liquid valve",
                "pressure drop"
            ]
        ),
        destination: { LiquidControlValveSizingView() }
    )
}
