import SwiftUI

enum HeatExchangerLMTDModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .heatExchangerLMTD,
            title:
                "Heat Exchanger — LMTD",
            subtitle:
                "Calculate heat-exchanger duty using the LMTD method",
            category:
                .heatTransfer,
            symbolName:
                "arrow.left.arrow.right",
            keywords: [
                "heat exchanger",
                "LMTD",
                "log mean temperature difference",
                "parallel flow",
                "counter flow",
                "overall heat transfer coefficient",
                "correction factor",
                "heat exchanger duty",
                "heat transfer area"
            ]
        ),
        destination: {
            HeatExchangerLMTDView()
        }
    )
}
