import SwiftUI

enum StreamSplitterBalanceModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .streamSplitterBalance,
            title: "Stream Splitter Balance",
            subtitle: "Split flow while preserving composition",
            category: .materialAndEnergyBalances,
            symbolName: "arrow.triangle.branch",
            keywords: [
                "stream splitter",
                "split fraction",
                "product flow",
                "mass balance",
                "composition"
            ]
        ),
        destination: {
            StreamSplitterBalanceView()
        }
    )
}
