import SwiftUI

enum BETIsothermModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .betIsotherm,
            title: "BET Isotherm",
            subtitle:
                "Calculate multilayer loading, BET transform and surface area",
            category: .massTransfer,
            symbolName:
                "square.stack.3d.up.fill",
            keywords: [
                "BET isotherm",
                "multilayer adsorption",
                "monolayer capacity",
                "specific surface area",
                "relative pressure",
                "BET transform"
            ]
        ),
        destination: {
            BETIsothermView()
        }
    )
}
