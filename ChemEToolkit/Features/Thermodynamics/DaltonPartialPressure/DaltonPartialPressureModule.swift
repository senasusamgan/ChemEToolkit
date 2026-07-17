import SwiftUI

enum DaltonPartialPressureModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .daltonPartialPressure,
            title: "Dalton Partial Pressure",
            subtitle: "Calculate gas-mixture partial pressures",
            category: .thermodynamics,
            symbolName: "chart.pie.fill",
            keywords: [
                "Dalton law",
                "partial pressure",
                "gas mixture",
                "mole fraction",
                "ideal gas"
            ]
        ),
        destination: {
            DaltonPartialPressureView()
        }
    )
}
