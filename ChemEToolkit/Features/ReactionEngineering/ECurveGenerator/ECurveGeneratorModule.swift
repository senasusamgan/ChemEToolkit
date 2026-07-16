import SwiftUI

enum ECurveGeneratorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .eCurveGenerator,
            title: "E-Curve Generator",
            subtitle: "Normalize pulse-tracer data into the exit-age distribution E(t)",
            category: .reactionEngineering,
            symbolName: "waveform.path.ecg",
            keywords: [
                "E curve",
                "pulse tracer",
                "RTD normalization",
                "exit age distribution",
                "residence time"
            ]
        ),
        destination: {
            ECurveGeneratorView()
        }
    )
}
