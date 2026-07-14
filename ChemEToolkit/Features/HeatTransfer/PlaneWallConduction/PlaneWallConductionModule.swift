import SwiftUI

enum PlaneWallConductionModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .planeWallConduction,
            title:
                "Plane Wall Conduction",
            subtitle:
                "Calculate steady-state heat conduction through a plane wall",
            category:
                .heatTransfer,
            symbolName:
                "square.stack.3d.up.fill",
            keywords: [
                "plane wall conduction",
                "conduction",
                "Fourier law",
                "Fourier's law",
                "thermal conductivity",
                "heat transfer",
                "heat transfer rate",
                "heat flux",
                "thermal resistance",
                "wall thickness",
                "temperature difference",
                "steady state conduction"
            ]
        ),
        destination: {
            PlaneWallConductionView()
        }
    )
}
