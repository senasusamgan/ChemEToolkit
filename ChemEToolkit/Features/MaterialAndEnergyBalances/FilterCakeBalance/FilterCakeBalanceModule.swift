import SwiftUI

enum FilterCakeBalanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .filterCakeBalance,
            title: "Filter Cake Balance",
            subtitle: "Calculate cake moisture and filtrate flow",
            category: .materialAndEnergyBalances,
            symbolName: "line.3.horizontal.decrease.circle",
            keywords: [
                "filter cake",
                "filtration balance",
                "cake moisture",
                "filtrate",
                "dry solids"
            ]
        ),
        destination: {
            FilterCakeBalanceView()
        }
    )
}
