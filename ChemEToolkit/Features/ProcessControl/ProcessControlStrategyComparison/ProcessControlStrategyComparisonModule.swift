import SwiftUI

enum ProcessControlStrategyComparisonModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .processControlStrategyComparison,
            title: "Control Strategy Comparison",
            subtitle: "Screen PID, feedforward, cascade and MPC",
            category: .processControl,
            symbolName: "list.bullet.rectangle",
            keywords: [
                "control strategy comparison",
                "PID selection",
                "feedforward",
                "cascade",
                "MPC selection"
            ]
        ),
        destination: { ProcessControlStrategyComparisonView() }
    )
}
