import SwiftUI

enum CentrifugeSigmaScaleUpModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .centrifugeSigmaScaleUp,
            title: "Centrifuge Sigma Scale-Up",
            subtitle: "Scale centrifuge throughput using equivalent settling area",
            category: .separationProcesses,
            symbolName: "circle.circle.fill",
            keywords: [
                "centrifuge sigma",
            "scale up",
            "equivalent settling area",
            "centrifuge throughput",
            "clarification"
            ]
        ),
        destination: { CentrifugeSigmaScaleUpView() }
    )
}
