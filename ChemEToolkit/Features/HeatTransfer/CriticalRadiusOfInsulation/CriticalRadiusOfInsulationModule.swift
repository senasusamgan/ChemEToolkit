import SwiftUI

enum CriticalRadiusOfInsulationModule {

    static let module = AppModule(
        metadata: ModuleMetadata(
            id:
                .criticalRadiusOfInsulation,
            title:
                "Critical Radius of Insulation",
            subtitle:
                "Evaluate cylindrical insulation and critical-radius behavior",
            category:
                .heatTransfer,
            symbolName:
                "circle.dashed.inset.filled",
            keywords: [
                "critical radius",
                "critical insulation radius",
                "pipe insulation",
                "cylindrical insulation",
                "thermal resistance",
                "conduction resistance",
                "convection resistance",
                "heat loss",
                "insulated pipe"
            ]
        ),
        destination: {
            CriticalRadiusOfInsulationView()
        }
    )
}
