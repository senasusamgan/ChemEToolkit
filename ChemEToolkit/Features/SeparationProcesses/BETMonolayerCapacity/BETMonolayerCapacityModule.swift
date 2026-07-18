import SwiftUI

enum BETMonolayerCapacityModule {
    static let module =
        AppModule(
            metadata:
                ModuleMetadata(
                    id:
                        .betMonolayerCapacity,
                    title:
                        "BET Monolayer Capacity",
                    subtitle:
                        "Calculate multilayer adsorption loading from relative pressure",
                    category: .separationProcesses,
                    symbolName:
                        "circle.grid.3x3.fill",
                    keywords: [
                        "BET isotherm",
                "monolayer capacity",
                "relative pressure",
                "multilayer adsorption",
                "surface area"
                    ]
                ),
            destination: {
                BETMonolayerCapacityView()
            }
        )
}
