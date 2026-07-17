import SwiftUI

enum TwoStreamMixerBalanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .twoStreamMixerBalance,
            title: "Two-Stream Mixer Balance",
            subtitle: "Mix two streams and calculate outlet composition",
            category: .materialAndEnergyBalances,
            symbolName: "arrow.triangle.merge",
            keywords: [
                "mixer balance",
                "two streams",
                "component balance",
                "outlet composition",
                "mass balance"
            ]
        ),
        destination: {
            TwoStreamMixerBalanceView()
        }
    )
}
