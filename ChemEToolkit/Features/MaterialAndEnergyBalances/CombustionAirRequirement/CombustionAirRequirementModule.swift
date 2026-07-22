import SwiftUI

enum CombustionAirRequirementModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .combustionAirRequirement,
            title: "Combustion Air Requirement",
            subtitle: "Calculate oxygen, air and flue-gas flows",
            category: .materialAndEnergyBalances,
            symbolName: "flame.circle.fill",
            keywords: [
                "combustion balance",
                "theoretical air",
                "excess air",
                "oxygen requirement",
                "flue gas"
            ]
        ),
        destination: {
            CombustionAirRequirementView()
        }
    )
}
