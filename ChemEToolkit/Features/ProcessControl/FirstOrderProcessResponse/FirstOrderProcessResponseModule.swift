import SwiftUI

enum FirstOrderProcessResponseModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .firstOrderProcessResponse,
            title: "First-Order Process",
            subtitle: "Calculate step response, time constant and settling behavior",
            category: .processControl,
            symbolName: "chart.line.uptrend.xyaxis",
            keywords: [
                "first order process",
                "step response",
                "time constant",
                "process gain",
                "settling time"
            ]
        ),
        destination: {
            FirstOrderProcessResponseView()
        }
    )
}
