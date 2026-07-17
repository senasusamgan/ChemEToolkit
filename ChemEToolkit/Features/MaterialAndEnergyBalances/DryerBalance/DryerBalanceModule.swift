import SwiftUI

enum DryerBalanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .dryerBalance,
            title: "Dryer Balance",
            subtitle: "Calculate water removal from wet solids",
            category: .materialAndEnergyBalances,
            symbolName: "humidity.fill",
            keywords: [
                "dryer balance",
                "moisture wet basis",
                "moisture dry basis",
                "water removal",
                "dry solids"
            ]
        ),
        destination: {
            DryerBalanceView()
        }
    )
}
