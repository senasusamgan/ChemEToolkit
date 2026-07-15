import SwiftUI

enum HumidificationPsychrometricsModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .humidificationPsychrometrics,
            title:
                "Humidification & Psychrometrics",
            subtitle:
                "Calculate humidity ratio, dew point, water transfer and heat duty",
            category: .massTransfer,
            symbolName: "drop.fill",
            keywords: [
                "humidification",
                "psychrometrics",
                "humidity ratio",
                "relative humidity",
                "dew point",
                "humid enthalpy"
            ]
        ),
        destination: {
            HumidificationPsychrometricsView()
        }
    )
}
