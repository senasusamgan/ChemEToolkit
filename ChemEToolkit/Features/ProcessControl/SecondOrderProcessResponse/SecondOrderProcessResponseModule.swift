import SwiftUI

enum SecondOrderProcessResponseModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .secondOrderProcessResponse,
            title: "Second-Order Process",
            subtitle: "Evaluate underdamped, critical and overdamped responses",
            category: .processControl,
            symbolName: "waveform.path",
            keywords: [
                "second order process",
                "damping ratio",
                "natural frequency",
                "overshoot",
                "settling time"
            ]
        ),
        destination: {
            SecondOrderProcessResponseView()
        }
    )
}
