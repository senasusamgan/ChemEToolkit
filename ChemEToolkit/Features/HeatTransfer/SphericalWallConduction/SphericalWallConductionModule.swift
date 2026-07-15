import SwiftUI

enum SphericalWallConductionModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .sphericalWallConduction,
            title: "Spherical Wall Conduction",
            subtitle:
                "Calculate radial conduction through a spherical shell",
            category: .heatTransfer,
            symbolName: "circle.circle.fill",
            keywords: [
                "spherical wall conduction",
                "sphere conduction",
                "radial conduction",
                "thermal resistance",
                "spherical shell",
                "heat flux",
                "steady state conduction"
            ]
        ),
        destination: {
            SphericalWallConductionView()
        }
    )
}
