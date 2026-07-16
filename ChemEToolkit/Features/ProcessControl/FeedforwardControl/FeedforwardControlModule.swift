import SwiftUI

enum FeedforwardControlModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .feedforwardControl,
            title: "Feedforward Control",
            subtitle: "Calculate disturbance compensation",
            category: .processControl,
            symbolName: "arrow.triangle.branch",
            keywords: [
                "feedforward control",
                "disturbance compensation",
                "steady state gain",
                "actuator saturation",
                "advanced control"
            ]
        ),
        destination: {
            FeedforwardControlView()
        }
    )
}
