import SwiftUI

enum ConvectionHeatTransferModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .convectionHeatTransfer,
            title:
                "Convection Heat Transfer",
            subtitle:
                "Calculate heat transfer between a surface and a fluid",
            category:
                .heatTransfer,
            symbolName:
                "wind",
            keywords: [
                "convection",
                "convection heat transfer",
                "Newton law of cooling",
                "Newton's law of cooling",
                "heat transfer coefficient",
                "surface temperature",
                "fluid temperature",
                "ambient temperature",
                "heat transfer rate",
                "heat flux",
                "convection resistance",
                "thermal resistance"
            ]
        ),
        destination: {
            ConvectionHeatTransferView()
        }
    )
}
