import SwiftUI

enum DoublePipeHeatExchangerModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .doublePipeHeatExchanger,
            title:
                "Double-Pipe Heat Exchanger",
            subtitle:
                "Size tube length and area for a double-pipe exchanger",
            category:
                .heatTransfer,
            symbolName:
                "arrow.left.arrow.right",
            keywords: [
                "double pipe heat exchanger",
                "hairpin exchanger",
                "tube length",
                "heat exchanger sizing",
                "required area",
                "LMTD",
                "parallel flow",
                "counter flow",
                "overall coefficient"
            ]
        ),
        destination: {
            DoublePipeHeatExchangerView()
        }
    )
}
