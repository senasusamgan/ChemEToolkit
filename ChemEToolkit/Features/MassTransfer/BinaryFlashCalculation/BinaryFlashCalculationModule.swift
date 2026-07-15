import SwiftUI

enum BinaryFlashCalculationModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .binaryFlashCalculation,
            title: "Binary Flash Calculation",
            subtitle: "Solve phase state, vapor fraction and binary equilibrium compositions",
            category: .massTransfer,
            symbolName: "circle.lefthalf.filled",
            keywords: ["flash calculation", "Rachford Rice", "K value", "vapor fraction", "bubble point", "dew point"]
        ),
        destination: { BinaryFlashCalculationView() }
    )
}
