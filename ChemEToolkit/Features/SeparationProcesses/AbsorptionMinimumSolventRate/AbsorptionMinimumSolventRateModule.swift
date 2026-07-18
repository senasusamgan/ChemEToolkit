import SwiftUI

enum AbsorptionMinimumSolventRateModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .absorptionMinimumSolventRate,
            title: "Minimum Solvent Rate for Absorption",
            subtitle: "Estimate minimum and design solvent flow",
            category: .separationProcesses,
            symbolName: "arrow.down.to.line.compact",
            keywords: [
                "minimum solvent",
            "absorption",
            "equilibrium slope",
            "solvent flow",
            "absorber"
            ]
        ),
        destination: { AbsorptionMinimumSolventRateView() }
    )
}
