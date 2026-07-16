import SwiftUI

enum TemperatureProcessDynamicsModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .temperatureProcessDynamics,
            title: "Temperature-Process Dynamics",
            subtitle: "Calculate a well-mixed thermal process response",
            category: .processControl,
            symbolName: "thermometer.medium",
            keywords: [
                "temperature process dynamics",
                "thermal capacitance",
                "well mixed tank",
                "heat transfer",
                "first order temperature"
            ]
        ),
        destination: {
            TemperatureProcessDynamicsView()
        }
    )
}
