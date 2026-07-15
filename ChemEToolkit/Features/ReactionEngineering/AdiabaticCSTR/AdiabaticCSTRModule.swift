import SwiftUI

enum AdiabaticCSTRModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .adiabaticCSTR,
            title: "Adiabatic CSTR",
            subtitle: "Size a perfectly mixed reactor at a target conversion and temperature",
            category: .reactionEngineering,
            symbolName: "thermometer.sun.fill",
            keywords: [
                "adiabatic CSTR",
                "energy balance",
                "Arrhenius kinetics",
                "reactor sizing",
                "exothermic reaction"
            ]
        ),
        destination: {
            AdiabaticCSTRView()
        }
    )
}
