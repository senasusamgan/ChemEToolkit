import SwiftUI

enum RaoultDewPointPressureModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .raoultDewPointPressure,
            title: "Raoult Dew-Point Pressure",
            subtitle: "Calculate ideal binary dew pressure",
            category: .separationProcesses,
            symbolName: "cloud.drizzle.fill",
            keywords: [
                "dew point",
                "Raoult law",
                "saturation pressure",
                "binary mixture",
                "VLE"
            ]
        ),
        destination: {
            RaoultDewPointPressureView()
        }
    )
}
