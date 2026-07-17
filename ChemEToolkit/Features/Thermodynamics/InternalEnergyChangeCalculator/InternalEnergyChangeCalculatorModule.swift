import SwiftUI

enum InternalEnergyChangeCalculatorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .internalEnergyChangeCalculator,
            title: "Internal-Energy Change",
            subtitle: "Calculate constant-Cv specific and total internal-energy change",
            category: .thermodynamics,
            symbolName: "bolt.horizontal.circle.fill",
            keywords: [
                "internal energy change",
                "specific internal energy",
                "constant Cv",
                "state function",
                "thermodynamics"
            ]
        ),
        destination: {
            InternalEnergyChangeCalculatorView()
        }
    )
}
