import SwiftUI

enum CondensationHeatTransferModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .condensationHeatTransfer,
            title: "Condensation Heat Transfer",
            subtitle:
                "Estimate condensation duty from temperature difference and coefficient",
            category: .heatTransfer,
            symbolName: "drop.fill",
            keywords: [
                "condensation heat transfer",
                "film condensation",
                "saturation temperature",
                "surface temperature",
                "heat flux",
                "phase change"
            ]
        ),
        destination: {
            CondensationHeatTransferView()
        }
    )
}
