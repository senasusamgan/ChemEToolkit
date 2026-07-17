import SwiftUI

enum ThermalEfficiencyCOPModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .thermalEfficiencyCOP,
            title: "Thermal Efficiency & COP",
            subtitle: "Calculate engine efficiency, refrigerator COP and heat-pump COP",
            category: .thermodynamics,
            symbolName: "arrow.triangle.2.circlepath.circle.fill",
            keywords: [
                "thermal efficiency",
                "refrigerator COP",
                "heat pump COP",
                "heat engine",
                "thermodynamic cycle"
            ]
        ),
        destination: { ThermalEfficiencyCOPView() }
    )
}
