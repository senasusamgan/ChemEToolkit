import SwiftUI

enum InteractingTankSystemModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .interactingTankSystem,
            title: "Interacting Tank System",
            subtitle: "Calculate coupled two-tank level dynamics",
            category: .processControl,
            symbolName: "square.stack.3d.down.right.fill",
            keywords: [
                "interacting tanks",
                "coupled tank dynamics",
                "liquid level",
                "hydraulic resistance",
                "second order process"
            ]
        ),
        destination: {
            InteractingTankSystemView()
        }
    )
}
