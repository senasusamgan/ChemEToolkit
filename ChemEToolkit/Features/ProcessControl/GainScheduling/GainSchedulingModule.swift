import SwiftUI

enum GainSchedulingModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .gainScheduling,
            title: "Gain Scheduling",
            subtitle: "Interpolate PID settings by operating point",
            category: .processControl,
            symbolName: "slider.horizontal.3",
            keywords: [
                "gain scheduling",
                "scheduled PID",
                "operating point",
                "parameter interpolation",
                "nonlinear process control"
            ]
        ),
        destination: {
            GainSchedulingView()
        }
    )
}
