import SwiftUI

enum PressureProcessDynamicsModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .pressureProcessDynamics,
            title: "Pressure-Process Dynamics",
            subtitle: "Calculate gas-vessel pressure response",
            category: .processControl,
            symbolName: "gauge.with.dots.needle.67percent",
            keywords: [
                "pressure process dynamics",
                "gas vessel",
                "pressure capacitance",
                "overpressure risk",
                "first order pressure"
            ]
        ),
        destination: {
            PressureProcessDynamicsView()
        }
    )
}
