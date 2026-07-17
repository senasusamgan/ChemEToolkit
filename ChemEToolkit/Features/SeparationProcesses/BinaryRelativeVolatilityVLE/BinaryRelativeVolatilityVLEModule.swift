import SwiftUI

enum BinaryRelativeVolatilityVLEModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .binaryRelativeVolatilityVLE,
            title: "Binary Relative-Volatility VLE",
            subtitle: "Calculate binary equilibrium vapor composition",
            category: .separationProcesses,
            symbolName: "chart.xyaxis.line",
            keywords: [
                "binary VLE",
                "relative volatility",
                "equilibrium curve",
                "vapor composition",
                "distillation"
            ]
        ),
        destination: {
            BinaryRelativeVolatilityVLEView()
        }
    )
}
