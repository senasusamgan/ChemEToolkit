import SwiftUI

enum IMCControllerTuningModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .imcControllerTuning,
            title: "IMC Controller Tuning",
            subtitle: "Tune robust PI and PID controllers with a selected λ",
            category: .processControl,
            symbolName: "gearshape.fill",
            keywords: [
                "IMC tuning",
                "lambda tuning",
                "robust PID",
                "FOPDT",
                "PI PID tuning"
            ]
        ),
        destination: {
            IMCControllerTuningView()
        }
    )
}
