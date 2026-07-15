import SwiftUI

enum HeatExchangerEffectivenessNTUModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .heatExchangerEffectivenessNTU,
            title:
                "Heat Exchanger Effectiveness–NTU",
            subtitle:
                "Predict exchanger duty and outlet temperatures using the NTU method",
            category:
                .heatTransfer,
            symbolName:
                "chart.line.uptrend.xyaxis",
            keywords: [
                "effectiveness NTU",
                "NTU method",
                "heat exchanger effectiveness",
                "number of transfer units",
                "capacity rate ratio",
                "outlet temperature",
                "parallel flow",
                "counter flow",
                "heat exchanger duty"
            ]
        ),
        destination: {
            HeatExchangerEffectivenessNTUView()
        }
    )
}
