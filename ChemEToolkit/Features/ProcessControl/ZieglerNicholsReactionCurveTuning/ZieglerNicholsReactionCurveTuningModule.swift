import SwiftUI

enum ZieglerNicholsReactionCurveTuningModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .zieglerNicholsReactionCurveTuning,
            title: "Ziegler–Nichols Reaction Curve",
            subtitle: "Tune P, PI and PID controllers from an FOPDT model",
            category: .processControl,
            symbolName: "chart.line.uptrend.xyaxis",
            keywords: [
                "Ziegler Nichols",
                "reaction curve",
                "FOPDT tuning",
                "open loop tuning",
                "PID tuning"
            ]
        ),
        destination: {
            ZieglerNicholsReactionCurveTuningView()
        }
    )
}
