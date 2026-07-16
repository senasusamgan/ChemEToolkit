import SwiftUI

enum PIControllerModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .piController,
            title: "PI Controller",
            subtitle: "Calculate proportional and integral controller action",
            category: .processControl,
            symbolName: "sum",
            keywords: ["process control", "controller", "pi controller"]
        ),
        destination: { PIControllerView() }
    )
}
