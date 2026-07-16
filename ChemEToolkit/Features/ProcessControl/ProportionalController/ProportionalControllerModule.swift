import SwiftUI

enum ProportionalControllerModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .proportionalController,
            title: "Proportional Controller",
            subtitle: "Calculate proportional action, bias and output saturation",
            category: .processControl,
            symbolName: "slider.horizontal.3",
            keywords: ["process control", "controller", "proportional controller"]
        ),
        destination: { ProportionalControllerView() }
    )
}
