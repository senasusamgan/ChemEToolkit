import SwiftUI

enum BoilingHeatTransferModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .boilingHeatTransfer,
            title: "Boiling Heat Transfer",
            subtitle:
                "Estimate boiling duty from wall superheat and coefficient",
            category: .heatTransfer,
            symbolName: "bubbles.and.sparkles.fill",
            keywords: [
                "boiling heat transfer",
                "wall superheat",
                "saturation temperature",
                "heat flux",
                "boiling coefficient",
                "phase change"
            ]
        ),
        destination: {
            BoilingHeatTransferView()
        }
    )
}
