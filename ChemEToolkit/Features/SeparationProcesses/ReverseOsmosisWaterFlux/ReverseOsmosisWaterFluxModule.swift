import SwiftUI

enum ReverseOsmosisWaterFluxModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .reverseOsmosisWaterFlux,
            title: "Reverse-Osmosis Water Flux",
            subtitle: "Calculate RO flux, area and concentrate flow",
            category: .separationProcesses,
            symbolName: "drop.triangle.fill",
            keywords: [
                "reverse osmosis",
                "water flux",
                "osmotic pressure",
                "membrane area",
                "recovery"
            ]
        ),
        destination: {
            ReverseOsmosisWaterFluxView()
        }
    )
}
