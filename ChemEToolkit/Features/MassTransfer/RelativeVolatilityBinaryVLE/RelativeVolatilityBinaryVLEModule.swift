import SwiftUI

enum RelativeVolatilityBinaryVLEModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .relativeVolatilityBinaryVLE,
            title: "Relative Volatility & Binary VLE",
            subtitle: "Convert binary liquid and vapor equilibrium compositions",
            category: .massTransfer,
            symbolName: "arrow.up.right.circle.fill",
            keywords: ["relative volatility", "binary VLE", "vapor liquid equilibrium", "distillation"]
        ),
        destination: { RelativeVolatilityBinaryVLEView() }
    )
}
