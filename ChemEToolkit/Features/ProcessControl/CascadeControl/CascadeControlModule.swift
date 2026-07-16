import SwiftUI

enum CascadeControlModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .cascadeControl,
            title: "Cascade Control",
            subtitle: "Analyze nested inner and outer loops",
            category: .processControl,
            symbolName: "point.3.connected.trianglepath.dotted",
            keywords: [
                "cascade control",
                "inner loop",
                "outer loop",
                "secondary disturbance",
                "advanced feedback"
            ]
        ),
        destination: {
            CascadeControlView()
        }
    )
}
