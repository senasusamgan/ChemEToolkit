import SwiftUI

enum FaultTreeProbabilityModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .faultTreeProbability,
            title: "Fault Tree Probability",
            subtitle: "Combine independent basic-event probabilities",
            category: .processSafetyAndEconomics,
            symbolName: "point.3.connected.trianglepath.dotted",
            keywords: [
                "fault tree",
                "OR gate",
                "AND gate",
                "top event probability",
                "basic event"
            ]
        ),
        destination: {
            FaultTreeProbabilityView()
        }
    )
}
