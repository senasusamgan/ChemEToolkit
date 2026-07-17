import SwiftUI

enum HumidifierWaterBalanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .humidifierWaterBalance,
            title: "Humidifier Water Balance",
            subtitle: "Calculate water addition to a gas stream",
            category: .materialAndEnergyBalances,
            symbolName: "humidity.fill",
            keywords: [
                "humidifier balance",
                "humidity ratio",
                "water addition",
                "dry gas basis",
                "humid gas"
            ]
        ),
        destination: {
            HumidifierWaterBalanceView()
        }
    )
}
