import SwiftUI

enum SensibleHeatBalanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .sensibleHeatBalance,
            title: "Sensible Heat Balance",
            subtitle: "Calculate constant-Cp heating or cooling duty",
            category: .materialAndEnergyBalances,
            symbolName: "thermometer.medium",
            keywords: [
                "sensible heat",
                "energy balance",
                "heat duty",
                "specific heat",
                "temperature change"
            ]
        ),
        destination: {
            SensibleHeatBalanceView()
        }
    )
}
