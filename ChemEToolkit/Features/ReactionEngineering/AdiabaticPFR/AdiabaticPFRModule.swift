import SwiftUI

enum AdiabaticPFRModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .adiabaticPFR,
            title: "Adiabatic PFR",
            subtitle: "Integrate reactor volume as temperature changes with conversion",
            category: .reactionEngineering,
            symbolName: "flame.circle.fill",
            keywords: [
                "adiabatic PFR",
                "energy balance",
                "Arrhenius kinetics",
                "Simpson integration",
                "reactor sizing"
            ]
        ),
        destination: {
            AdiabaticPFRView()
        }
    )
}
