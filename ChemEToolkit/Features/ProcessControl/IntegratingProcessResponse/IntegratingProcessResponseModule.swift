import SwiftUI

enum IntegratingProcessResponseModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .integratingProcessResponse,
            title: "Integrating Process",
            subtitle: "Calculate ramp response and target reach time",
            category: .processControl,
            symbolName: "arrow.up.right",
            keywords: [
                "integrating process",
                "ramp response",
                "liquid level",
                "inventory process",
                "dead time"
            ]
        ),
        destination: {
            IntegratingProcessResponseView()
        }
    )
}
