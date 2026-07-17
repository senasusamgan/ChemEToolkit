import SwiftUI

enum EquipmentCostScalingModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .equipmentCostScaling,
            title: "Equipment Cost Scaling",
            subtitle: "Scale equipment cost with capacity",
            category: .processSafetyAndEconomics,
            symbolName: "arrow.up.right.circle.fill",
            keywords: [
                "equipment cost scaling",
                "six tenths rule",
                "cost capacity exponent",
                "economies of scale",
                "capital cost"
            ]
        ),
        destination: {
            EquipmentCostScalingView()
        }
    )
}
