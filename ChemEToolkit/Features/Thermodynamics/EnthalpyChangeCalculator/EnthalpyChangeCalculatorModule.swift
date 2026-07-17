import SwiftUI

enum EnthalpyChangeCalculatorModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .enthalpyChangeCalculator,
            title: "Enthalpy Change",
            subtitle: "Calculate constant-Cp specific and total enthalpy change",
            category: .thermodynamics,
            symbolName: "thermometer.sun.fill",
            keywords: [
                "enthalpy change",
                "specific enthalpy",
                "constant Cp",
                "state function",
                "thermodynamics"
            ]
        ),
        destination: {
            EnthalpyChangeCalculatorView()
        }
    )
}
