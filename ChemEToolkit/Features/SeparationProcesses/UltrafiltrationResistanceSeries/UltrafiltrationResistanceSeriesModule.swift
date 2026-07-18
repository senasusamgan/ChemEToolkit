import SwiftUI

enum UltrafiltrationResistanceSeriesModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .ultrafiltrationResistanceSeries,
            title: "Ultrafiltration Resistance Series",
            subtitle: "Calculate clean and fouled membrane flux",
            category: .separationProcesses,
            symbolName: "line.3.horizontal.decrease.circle.fill",
            keywords: [
                "ultrafiltration",
                "resistance in series",
                "fouling",
                "membrane flux",
                "transmembrane pressure"
            ]
        ),
        destination: {
            UltrafiltrationResistanceSeriesView()
        }
    )
}
