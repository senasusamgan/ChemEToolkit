import SwiftUI

enum ForcedConvectionCorrelationModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .forcedConvectionCorrelation,
            title: "Forced Convection Correlations",
            subtitle:
                "Estimate Nusselt number and heat-transfer coefficient",
            category: .heatTransfer,
            symbolName: "wind",
            keywords: [
                "forced convection",
                "Dittus Boelter",
                "flat plate",
                "Nusselt number",
                "heat transfer coefficient",
                "Reynolds number",
                "Prandtl number"
            ]
        ),
        destination: {
            ForcedConvectionCorrelationView()
        }
    )
}
