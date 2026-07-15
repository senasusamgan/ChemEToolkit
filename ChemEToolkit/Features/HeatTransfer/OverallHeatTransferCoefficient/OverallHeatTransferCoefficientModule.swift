import SwiftUI

enum OverallHeatTransferCoefficientModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .overallHeatTransferCoefficient,
            title:
                "Overall Heat Transfer Coefficient",
            subtitle:
                "Combine convection, conduction and fouling resistances",
            category:
                .heatTransfer,
            symbolName:
                "rectangle.split.3x1.fill",
            keywords: [
                "overall heat transfer coefficient",
                "overall coefficient",
                "U value",
                "thermal resistance",
                "convection resistance",
                "conduction resistance",
                "fouling resistance",
                "heat exchanger",
                "wall resistance"
            ]
        ),
        destination: {
            OverallHeatTransferCoefficientView()
        }
    )
}
