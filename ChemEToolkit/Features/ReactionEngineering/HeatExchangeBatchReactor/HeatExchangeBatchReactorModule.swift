import SwiftUI

enum HeatExchangeBatchReactorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .heatExchangeBatchReactor,
            title: "Heat-Exchange Batch Reactor",
            subtitle: "Integrate conversion and temperature with coolant heat removal",
            category: .reactionEngineering,
            symbolName: "thermometer.and.liquid.waves",
            keywords: [
                "heat exchange batch",
                "non-isothermal batch",
                "coolant",
                "Arrhenius kinetics",
                "RK4"
            ]
        ),
        destination: {
            HeatExchangeBatchReactorView()
        }
    )
}
