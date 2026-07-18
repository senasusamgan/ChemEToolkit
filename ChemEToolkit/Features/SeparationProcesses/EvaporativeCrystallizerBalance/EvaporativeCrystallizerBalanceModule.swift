import SwiftUI

enum EvaporativeCrystallizerBalanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .evaporativeCrystallizerBalance,
            title: "Evaporative Crystallizer Balance",
            subtitle: "Solve crystal, mother-liquor and evaporation flows",
            category: .separationProcesses,
            symbolName: "aqi.medium",
            keywords: [
                "evaporative crystallizer",
                "mother liquor",
                "crystal purity",
                "mass balance",
                "solute recovery"
            ]
        ),
        destination: {
            EvaporativeCrystallizerBalanceView()
        }
    )
}
