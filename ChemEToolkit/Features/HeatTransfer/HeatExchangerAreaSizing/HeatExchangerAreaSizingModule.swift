import SwiftUI

enum HeatExchangerAreaSizingModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .heatExchangerAreaSizing,
            title:
                "Heat Exchanger Area Sizing",
            subtitle:
                "Calculate required exchanger area using the LMTD method",
            category:
                .heatTransfer,
            symbolName:
                "ruler.fill",
            keywords: [
                "heat exchanger area",
                "heat exchanger sizing",
                "LMTD sizing",
                "required area",
                "design duty",
                "overall coefficient",
                "correction factor",
                "parallel flow",
                "counter flow"
            ]
        ),
        destination: {
            HeatExchangerAreaSizingView()
        }
    )
}
