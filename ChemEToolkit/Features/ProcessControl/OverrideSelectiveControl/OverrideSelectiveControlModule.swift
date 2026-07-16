import SwiftUI

enum OverrideSelectiveControlModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .overrideSelectiveControl,
            title: "Override / Selective Control",
            subtitle: "Select a primary or constraint controller",
            category: .processControl,
            symbolName: "arrow.up.arrow.down.circle.fill",
            keywords: [
                "override control",
                "selective control",
                "high selector",
                "low selector",
                "constraint control"
            ]
        ),
        destination: {
            OverrideSelectiveControlView()
        }
    )
}
