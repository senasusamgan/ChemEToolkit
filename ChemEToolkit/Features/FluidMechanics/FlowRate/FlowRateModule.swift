import SwiftUI

enum FlowRateModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .flowRate,
            title:
                "Volumetric & Mass Flow Rate",
            subtitle:
                "Calculate flow rates through a circular pipe",
            category:
                .fluidMechanics,
            symbolName:
                "arrow.right.to.line.compact",
            keywords: [
                "flow rate",
                "volumetric flow rate",
                "mass flow rate",
                "volume flow",
                "pipe area",
                "cross sectional area",
                "average velocity",
                "density",
                "circular pipe",
                "litres per second",
                "cubic metres per hour",
                "fluid mechanics"
            ]
        ),
        destination: {
            FlowRateView()
        }
    )
}
