import SwiftUI

enum FinHeatTransferModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .finHeatTransfer,
            title:
                "Fin Efficiency & Heat Transfer",
            subtitle:
                "Calculate heat transfer from a straight rectangular fin",
            category:
                .heatTransfer,
            symbolName:
                "lines.measurement.horizontal",
            keywords: [
                "fin heat transfer",
                "fin efficiency",
                "fin effectiveness",
                "extended surface",
                "rectangular fin",
                "adiabatic tip",
                "thermal conductivity",
                "convection",
                "heat sink"
            ]
        ),
        destination: {
            FinHeatTransferView()
        }
    )
}
