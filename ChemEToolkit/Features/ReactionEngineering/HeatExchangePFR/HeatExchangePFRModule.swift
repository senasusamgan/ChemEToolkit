import SwiftUI

enum HeatExchangePFRModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .heatExchangePFR,
            title: "Heat-Exchange PFR",
            subtitle: "Integrate residence time and temperature with coolant heat transfer",
            category: .reactionEngineering,
            symbolName: "waveform.path.ecg.rectangle.fill",
            keywords: [
                "heat exchange PFR",
                "non-isothermal PFR",
                "coolant",
                "energy balance",
                "RK4"
            ]
        ),
        destination: {
            HeatExchangePFRView()
        }
    )
}
