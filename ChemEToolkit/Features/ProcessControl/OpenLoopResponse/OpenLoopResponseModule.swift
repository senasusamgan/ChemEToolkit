import SwiftUI

enum OpenLoopResponseModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .openLoopResponse,
            title: "Open-Loop Response",
            subtitle: "Evaluate process response without feedback",
            category: .processControl,
            symbolName: "arrow.right",
            keywords: [
                "open loop response",
                "FOPDT",
                "controller saturation",
                "process response",
                "no feedback"
            ]
        ),
        destination: {
            OpenLoopResponseView()
        }
    )
}
