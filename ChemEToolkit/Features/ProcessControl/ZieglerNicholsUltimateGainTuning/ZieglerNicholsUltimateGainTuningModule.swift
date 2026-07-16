import SwiftUI

enum ZieglerNicholsUltimateGainTuningModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .zieglerNicholsUltimateGainTuning,
            title: "Ziegler–Nichols Ultimate Gain",
            subtitle: "Generate P, PI and PID settings from Kᵤ and Pᵤ",
            category: .processControl,
            symbolName: "slider.horizontal.3",
            keywords: [
                "Ziegler Nichols",
                "ultimate gain",
                "ultimate period",
                "closed loop tuning",
                "PID tuning"
            ]
        ),
        destination: {
            ZieglerNicholsUltimateGainTuningView()
        }
    )
}
