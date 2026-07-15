import SwiftUI

enum LumpedCapacitanceModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .lumpedCapacitance,
            title:
                "Transient Lumped-Capacitance Method",
            subtitle:
                "Predict uniform object temperature during transient heating or cooling",
            category: .heatTransfer,
            symbolName:
                "thermometer.medium.slash",
            keywords: [
                "lumped capacitance",
                "transient heat transfer",
                "cooling",
                "heating",
                "time constant",
                "Biot number",
                "Newton cooling",
                "temperature versus time"
            ]
        ),
        destination: {
            LumpedCapacitanceView()
        }
    )
}
