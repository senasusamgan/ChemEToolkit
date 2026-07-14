import SwiftUI

enum IdealGasModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .idealGas,
            title: "Ideal Gas Calculator",
            subtitle: "Solve ideal gas law calculations",
            category: .thermodynamics,
            symbolName: "wind",
            keywords: [
                "ideal gas",
                "pressure",
                "volume",
                "temperature",
                "moles",
                "PV=nRT"
            ],
            isFeatured: true
        ),
        destination: {
            IdealGasView()
        }
    )
}
