import SwiftUI

enum CoolingCrystallizerYieldModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .coolingCrystallizerYield,
            title: "Cooling Crystallizer Yield",
            subtitle: "Estimate crystal recovery from solubility change",
            category: .separationProcesses,
            symbolName: "snowflake",
            keywords: [
                "cooling crystallization",
                "solubility",
                "crystal yield",
                "mother liquor",
                "recovery"
            ]
        ),
        destination: {
            CoolingCrystallizerYieldView()
        }
    )
}
