import SwiftUI

enum MembraneSeparatorBalanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .membraneSeparatorBalance,
            title: "Membrane Separator Balance",
            subtitle: "Calculate stage-cut and rejection balances",
            category: .materialAndEnergyBalances,
            symbolName: "rectangle.split.3x1",
            keywords: [
                "membrane separator",
                "stage cut",
                "rejection",
                "permeate",
                "retentate"
            ]
        ),
        destination: {
            MembraneSeparatorBalanceView()
        }
    )
}
