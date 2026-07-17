import SwiftUI

enum BypassMixingBalanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .bypassMixingBalance,
            title: "Bypass Mixing Balance",
            subtitle: "Calculate split, process and remix composition",
            category: .materialAndEnergyBalances,
            symbolName: "arrow.triangle.turn.up.right.diamond.fill",
            keywords: [
                "bypass stream",
                "remixing",
                "component balance",
                "processed stream",
                "mass balance"
            ]
        ),
        destination: {
            BypassMixingBalanceView()
        }
    )
}
