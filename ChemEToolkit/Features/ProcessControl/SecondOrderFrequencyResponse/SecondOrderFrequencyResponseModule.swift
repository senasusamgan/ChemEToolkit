import SwiftUI

enum SecondOrderFrequencyResponseModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .secondOrderFrequencyResponse,
            title: "Second-Order Frequency Response",
            subtitle: "Evaluate magnitude, phase and resonance",
            category: .processControl,
            symbolName: "waveform.path.ecg",
            keywords: [
                "second order frequency response",
                "resonance",
                "Bode magnitude",
                "damping ratio",
                "natural frequency"
            ]
        ),
        destination: { SecondOrderFrequencyResponseView() }
    )
}
