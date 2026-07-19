import SwiftUI

enum ShootingMethodBoundaryValueModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .shootingMethodBoundaryValue,
            title: "Shooting Method Boundary Value",
            subtitle: "Solve y'' + ky = 0 with endpoint conditions",
            category: .numericalMethods,
            symbolName: "scope",
            keywords: [
                "shooting method boundary value",
                "numerical methods",
                "advanced solver"
            ]
        ),
        destination: {
            ShootingMethodBoundaryValueView()
        }
    )
}
