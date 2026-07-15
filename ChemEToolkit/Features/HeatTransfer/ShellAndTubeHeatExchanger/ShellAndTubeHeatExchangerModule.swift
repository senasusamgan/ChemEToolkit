import SwiftUI

enum ShellAndTubeHeatExchangerModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .shellAndTubeHeatExchanger,
            title:
                "Shell-and-Tube Heat Exchanger",
            subtitle:
                "Estimate tube count, area and design margin",
            category:
                .heatTransfer,
            symbolName:
                "square.grid.3x3.fill",
            keywords: [
                "shell and tube",
                "heat exchanger",
                "tube count",
                "tube passes",
                "required area",
                "design margin",
                "LMTD correction factor",
                "preliminary sizing",
                "tube bundle"
            ]
        ),
        destination: {
            ShellAndTubeHeatExchangerView()
        }
    )
}
