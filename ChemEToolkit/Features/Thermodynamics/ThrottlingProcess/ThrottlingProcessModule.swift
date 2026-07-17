import SwiftUI

enum ThrottlingProcessModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .throttlingProcess,
            title: "Throttling Process",
            subtitle: "Estimate pressure-drop temperature change at constant enthalpy",
            category: .thermodynamics,
            symbolName: "valve.open.fill",
            keywords: [
                "throttling",
                "Joule Thomson",
                "constant enthalpy",
                "valve",
                "pressure drop"
            ]
        ),
        destination: { ThrottlingProcessView() }
    )
}
