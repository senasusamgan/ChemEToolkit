import SwiftUI

enum NonInteractingTankSystemModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .nonInteractingTankSystem,
            title: "Non-Interacting Tank System",
            subtitle: "Calculate two-tank cascade dynamics",
            category: .processControl,
            symbolName: "square.stack.3d.up.fill",
            keywords: [
                "non interacting tanks",
                "tank cascade",
                "liquid level",
                "time constants",
                "process dynamics"
            ]
        ),
        destination: {
            NonInteractingTankSystemView()
        }
    )
}
