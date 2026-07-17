import SwiftUI

enum IsochoricIdealGasProcessModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .isochoricIdealGasProcess,
            title: "Isochoric Ideal-Gas Process",
            subtitle: "Calculate constant-volume heat and pressure ratio",
            category: .thermodynamics,
            symbolName: "shippingbox.fill",
            keywords: [
                "isochoric process",
                "constant volume",
                "rigid vessel",
                "internal energy",
                "ideal gas"
            ]
        ),
        destination: {
            IsochoricIdealGasProcessView()
        }
    )
}
