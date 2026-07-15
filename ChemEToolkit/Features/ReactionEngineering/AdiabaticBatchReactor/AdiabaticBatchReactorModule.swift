import SwiftUI

enum AdiabaticBatchReactorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .adiabaticBatchReactor,
            title: "Adiabatic Batch Reactor",
            subtitle: "Calculate time and temperature for a target first-order conversion",
            category: .reactionEngineering,
            symbolName: "flame.fill",
            keywords: [
                "adiabatic batch reactor",
                "energy balance",
                "Arrhenius kinetics",
                "temperature conversion",
                "exothermic reaction"
            ]
        ),
        destination: {
            AdiabaticBatchReactorView()
        }
    )
}
