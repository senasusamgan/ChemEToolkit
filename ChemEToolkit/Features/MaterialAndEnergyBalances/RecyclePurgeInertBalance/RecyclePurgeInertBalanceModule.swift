import SwiftUI

enum RecyclePurgeInertBalanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .recyclePurgeInertBalance,
            title: "Recycle–Purge Inert Balance",
            subtitle: "Calculate recycle buildup and purge losses",
            category: .materialAndEnergyBalances,
            symbolName: "arrow.triangle.2.circlepath",
            keywords: [
                "recycle purge",
                "inert buildup",
                "single pass conversion",
                "overall conversion",
                "material balance"
            ]
        ),
        destination: {
            RecyclePurgeInertBalanceView()
        }
    )
}
