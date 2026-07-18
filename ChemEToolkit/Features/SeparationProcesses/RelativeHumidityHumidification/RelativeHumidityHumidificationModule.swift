import SwiftUI

enum RelativeHumidityHumidificationModule {
    static let module =
        AppModule(
            metadata:
                ModuleMetadata(
                    id:
                        .relativeHumidityHumidification,
                    title:
                        "Relative-Humidity Humidification",
                    subtitle:
                        "Calculate water demand for a target relative humidity",
                    category: .separationProcesses,
                    symbolName:
                        "humidity.badge.plus",
                    keywords: [
                        "relative humidity",
                "humidification",
                "water requirement",
                "psychrometrics",
                "humidity ratio"
                    ]
                ),
            destination: {
                RelativeHumidityHumidificationView()
            }
        )
}
