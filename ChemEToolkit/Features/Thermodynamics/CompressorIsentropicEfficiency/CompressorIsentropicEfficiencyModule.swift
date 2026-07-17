import SwiftUI

enum CompressorIsentropicEfficiencyModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .compressorIsentropicEfficiency,
            title: "Compressor Isentropic Efficiency",
            subtitle: "Calculate compressor efficiency and power input",
            category: .thermodynamics,
            symbolName: "arrow.up.forward.circle.fill",
            keywords: [
                "compressor efficiency",
                "isentropic efficiency",
                "power input",
                "enthalpy rise",
                "steady flow"
            ]
        ),
        destination: { CompressorIsentropicEfficiencyView() }
    )
}
