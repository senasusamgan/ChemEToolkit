import SwiftUI

enum SoluteDilutionCalculatorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .soluteDilutionCalculator,
            title: "Solute Dilution Calculator",
            subtitle: "Calculate solvent addition for dilution",
            category: .materialAndEnergyBalances,
            symbolName: "drop.triangle.fill",
            keywords: [
                "dilution",
                "solute balance",
                "solvent addition",
                "target concentration",
                "mass fraction"
            ]
        ),
        destination: {
            SoluteDilutionCalculatorView()
        }
    )
}
