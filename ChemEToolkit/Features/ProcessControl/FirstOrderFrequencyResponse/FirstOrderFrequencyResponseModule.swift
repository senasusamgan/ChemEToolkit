import SwiftUI

enum FirstOrderFrequencyResponseModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .firstOrderFrequencyResponse,
            title: "First-Order Frequency Response",
            subtitle: "Evaluate magnitude, phase and cutoff behavior",
            category: .processControl,
            symbolName: "waveform.path",
            keywords: [
                "first order frequency response",
                "Bode magnitude",
                "Bode phase",
                "cutoff frequency",
                "transfer function"
            ]
        ),
        destination: { FirstOrderFrequencyResponseView() }
    )
}
