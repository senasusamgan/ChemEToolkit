import SwiftUI

enum OrificeMeterModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .orificeMeter,
            title: "Orifice Meter",
            subtitle:
                "Calculate flow rate across a sharp-edged orifice plate",
            category: .fluidMechanics,
            symbolName: "circle.dashed",
            keywords: [
                "orifice meter",
                "orifice plate",
                "flow measurement",
                "pressure difference",
                "differential pressure",
                "beta ratio",
                "discharge coefficient",
                "mass flow rate",
                "fluid mechanics"
            ]
        ),
        destination: {
            DifferentialPressureMeterView(
                meterType: .orifice
            )
        }
    )
}
