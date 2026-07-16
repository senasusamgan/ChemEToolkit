import SwiftUI

enum FirstOrderPlusDeadTimeProcessModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .firstOrderPlusDeadTimeProcess,
            title: "First-Order Plus Dead Time",
            subtitle: "Evaluate an FOPDT step response with process delay",
            category: .processControl,
            symbolName: "clock",
            keywords: [
                "FOPDT",
                "first order plus dead time",
                "transport delay",
                "process reaction curve",
                "step response"
            ]
        ),
        destination: {
            FirstOrderPlusDeadTimeProcessView()
        }
    )
}
