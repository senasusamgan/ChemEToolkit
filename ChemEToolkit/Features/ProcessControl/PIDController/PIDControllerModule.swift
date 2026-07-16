import SwiftUI

enum PIDControllerModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .pidController,
            title: "PID Controller",
            subtitle: "Calculate proportional, integral and derivative action",
            category: .processControl,
            symbolName: "dial.high.fill",
            keywords: ["process control", "controller", "pid controller"]
        ),
        destination: { PIDControllerView() }
    )
}
