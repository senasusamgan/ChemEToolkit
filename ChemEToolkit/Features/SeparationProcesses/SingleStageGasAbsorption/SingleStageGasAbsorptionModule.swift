import SwiftUI

enum SingleStageGasAbsorptionModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .singleStageGasAbsorption,
            title: "Single-Stage Gas Absorption",
            subtitle: "Calculate one-stage gas-solute removal",
            category: .separationProcesses,
            symbolName: "wind.and.rain",
            keywords: [
                "gas absorption",
                "equilibrium stage",
                "solute removal",
                "Henry slope",
                "mass balance"
            ]
        ),
        destination: {
            SingleStageGasAbsorptionView()
        }
    )
}
