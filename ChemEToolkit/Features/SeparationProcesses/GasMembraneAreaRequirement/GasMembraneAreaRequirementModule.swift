import SwiftUI

enum GasMembraneAreaRequirementModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .gasMembraneAreaRequirement,
            title: "Gas-Membrane Area Requirement",
            subtitle: "Size area from permeance and pressure difference",
            category: .separationProcesses,
            symbolName: "square.resize.up",
            keywords: [
                "membrane area",
                "gas permeance",
                "partial pressure",
                "membrane flux",
                "module utilization"
            ]
        ),
        destination: {
            GasMembraneAreaRequirementView()
        }
    )
}
