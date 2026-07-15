import SwiftUI

enum ThermalResistanceNetworkModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .thermalResistanceNetwork,
            title: "Thermal Resistance Network",
            subtitle:
                "Combine thermal resistances in series or parallel",
            category: .heatTransfer,
            symbolName:
                "point.3.connected.trianglepath.dotted",
            keywords: [
                "thermal resistance network",
                "series resistance",
                "parallel resistance",
                "equivalent resistance",
                "heat transfer rate",
                "thermal circuit",
                "resistance branches"
            ]
        ),
        destination: {
            ThermalResistanceNetworkView()
        }
    )
}
