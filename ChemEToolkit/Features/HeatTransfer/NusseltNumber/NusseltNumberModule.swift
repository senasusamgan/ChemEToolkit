import SwiftUI

enum NusseltNumberModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .nusseltNumber,
            title: "Nusselt Number",
            subtitle:
                "Compare convection with conduction across a fluid layer",
            category: .heatTransfer,
            symbolName: "arrow.up.and.down.and.arrow.left.and.right",
            keywords: [
                "Nusselt number",
                "dimensionless number",
                "heat transfer coefficient",
                "characteristic length",
                "thermal conductivity",
                "convection correlation",
                "conduction",
                "heat transfer"
            ]
        ),
        destination: {
            NusseltNumberView()
        }
    )
}
