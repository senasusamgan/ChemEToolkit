import SwiftUI

enum VenturiMeterModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .venturiMeter,
            title: "Venturi Meter",
            subtitle:
                "Calculate flow rate from a measured pressure difference",
            category: .fluidMechanics,
            symbolName:
                "arrow.right.and.line.vertical.and.arrow.left",
            keywords: [
                "Venturi meter",
                "Venturi tube",
                "flow measurement",
                "pressure difference",
                "differential pressure",
                "throat diameter",
                "discharge coefficient",
                "mass flow rate",
                "fluid mechanics"
            ]
        ),
        destination: {
            DifferentialPressureMeterView(
                meterType: .venturi
            )
        }
    )
}
