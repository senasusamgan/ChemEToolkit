import SwiftUI

enum CylindricalWallConductionModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .cylindricalWallConduction,
            title:
                "Cylindrical Wall Conduction",
            subtitle:
                "Calculate radial conduction through cylindrical walls",
            category:
                .heatTransfer,
            symbolName:
                "cylinder.fill",
            keywords: [
                "cylindrical wall",
                "radial conduction",
                "pipe insulation",
                "thermal resistance",
                "inner radius",
                "outer radius",
                "heat flux",
                "Fourier law"
            ]
        ),
        destination: {
            CylindricalWallConductionView()
        }
    )
}
