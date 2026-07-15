import SwiftUI

enum CompositeWallConductionModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .compositeWallConduction,
            title:
                "Composite Wall Conduction",
            subtitle:
                "Calculate conduction through multiple wall layers",
            category:
                .heatTransfer,
            symbolName:
                "square.stack.3d.up.fill",
            keywords: [
                "composite wall",
                "multilayer wall",
                "conduction",
                "thermal resistance",
                "interface temperature",
                "Fourier law",
                "heat transfer",
                "insulation"
            ]
        ),
        destination: {
            CompositeWallConductionView()
        }
    )
}
