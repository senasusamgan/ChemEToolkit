import SwiftUI

enum HeatExchangerEnergyBalanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .heatExchangerEnergyBalance,
            title: "Heat Exchanger Energy Balance",
            subtitle: "Solve two-stream exchanger duty and outlet temperature",
            category: .materialAndEnergyBalances,
            symbolName: "arrow.left.arrow.right.square.fill",
            keywords: [
                "heat exchanger balance",
                "energy balance",
                "cold outlet temperature",
                "effectiveness",
                "heat duty"
            ]
        ),
        destination: {
            HeatExchangerEnergyBalanceView()
        }
    )
}
