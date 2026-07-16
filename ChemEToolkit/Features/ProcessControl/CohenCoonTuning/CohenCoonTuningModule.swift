import SwiftUI

enum CohenCoonTuningModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .cohenCoonTuning,
            title: "Cohen–Coon Tuning",
            subtitle: "Calculate P, PI and PID settings from an FOPDT model",
            category: .processControl,
            symbolName: "waveform.path.ecg",
            keywords: [
                "Cohen Coon",
                "FOPDT tuning",
                "open loop tuning",
                "dead time ratio",
                "PID tuning"
            ]
        ),
        destination: {
            CohenCoonTuningView()
        }
    )
}
