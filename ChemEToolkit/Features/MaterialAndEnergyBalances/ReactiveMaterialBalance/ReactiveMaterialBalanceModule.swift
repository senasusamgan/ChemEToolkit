import SwiftUI

enum ReactiveMaterialBalanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .reactiveMaterialBalance,
            title: "Reactive Material Balance",
            subtitle: "Calculate outlet flows from stoichiometry and conversion",
            category: .materialAndEnergyBalances,
            symbolName: "atom",
            keywords: [
                "reactive material balance",
                "conversion",
                "stoichiometry",
                "reaction extent",
                "product formation"
            ]
        ),
        destination: {
            ReactiveMaterialBalanceView()
        }
    )
}
