import SwiftUI

enum StrippingMinimumGasRateModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .strippingMinimumGasRate,
            title: "Minimum Gas Rate for Stripping",
            subtitle: "Estimate minimum and design stripping-gas flow",
            category: .separationProcesses,
            symbolName: "arrow.up.to.line.compact",
            keywords: [
                "minimum gas",
            "stripping",
            "equilibrium slope",
            "stripper",
            "gas rate"
            ]
        ),
        destination: { StrippingMinimumGasRateView() }
    )
}
