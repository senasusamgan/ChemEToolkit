import SwiftUI

enum AdaptiveRungeKutta45Module {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .adaptiveRungeKutta45,
            title: "Adaptive Runge–Kutta 4/5",
            subtitle: "Integrate dy/dx = ax + by with adaptive steps",
            category: .numericalMethods,
            symbolName: "waveform.path.ecg.rectangle.fill",
            keywords: [
                "adaptive runge–kutta 4/5",
                "numerical methods",
                "advanced solver"
            ]
        ),
        destination: {
            AdaptiveRungeKutta45View()
        }
    )
}
