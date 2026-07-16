import SwiftUI

enum SplitRangeControlModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .splitRangeControl,
            title: "Split-Range Control",
            subtitle: "Map one output across two actuators",
            category: .processControl,
            symbolName: "arrow.triangle.swap",
            keywords: [
                "split range control",
                "two valves",
                "actuator mapping",
                "heating cooling",
                "advanced control"
            ]
        ),
        destination: {
            SplitRangeControlView()
        }
    )
}
