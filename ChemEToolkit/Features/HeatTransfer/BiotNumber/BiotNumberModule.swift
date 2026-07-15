import SwiftUI

enum BiotNumberModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .biotNumber,
            title: "Biot Number",
            subtitle:
                "Compare internal conduction and surface convection resistance",
            category: .heatTransfer,
            symbolName: "cube.transparent.fill",
            keywords: [
                "Biot number",
                "lumped capacitance",
                "transient conduction",
                "internal resistance",
                "convection resistance",
                "thermal conductivity",
                "characteristic length",
                "dimensionless number"
            ]
        ),
        destination: {
            BiotNumberView()
        }
    )
}
