import SwiftUI

enum PDControllerModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .pdController,
            title: "PD Controller",
            subtitle: "Calculate proportional and derivative controller action",
            category: .processControl,
            symbolName: "speedometer",
            keywords: ["process control", "controller", "pd controller"]
        ),
        destination: { PDControllerView() }
    )
}
