import SwiftUI

enum PumpPowerModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .pumpPower,
            title: "Pump Power & Head",
            subtitle:
                "Calculate pressure rise and required pump shaft power",
            category: .fluidMechanics,
            symbolName: "bolt.fill",
            keywords: [
                "pump power",
                "pump head",
                "hydraulic power",
                "shaft power",
                "pump efficiency",
                "pressure increase",
                "volumetric flow",
                "fluid mechanics"
            ]
        ),
        destination: {
            PumpPowerView()
        }
    )
}
