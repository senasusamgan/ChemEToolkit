import SwiftUI

enum RatioControlModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .ratioControl,
            title: "Ratio Control",
            subtitle: "Calculate controlled flow from a wild stream",
            category: .processControl,
            symbolName: "divide.circle.fill",
            keywords: [
                "ratio control",
                "wild stream",
                "flow ratio",
                "ratio station",
                "advanced control"
            ]
        ),
        destination: {
            RatioControlView()
        }
    )
}
