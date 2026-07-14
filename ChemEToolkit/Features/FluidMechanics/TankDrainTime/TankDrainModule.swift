import SwiftUI

enum TankDrainModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .tankDrainTime,
            title: "Tank Drain Time",
            subtitle:
                "Calculate liquid discharge time through a tank orifice",
            category: .fluidMechanics,
            symbolName: "hourglass",
            keywords: [
                "tank drain",
                "tank emptying",
                "drain time",
                "Torricelli equation",
                "orifice flow",
                "discharge coefficient",
                "liquid level",
                "exit velocity",
                "fluid mechanics"
            ]
        ),
        destination: {
            TankDrainView()
        }
    )
}
