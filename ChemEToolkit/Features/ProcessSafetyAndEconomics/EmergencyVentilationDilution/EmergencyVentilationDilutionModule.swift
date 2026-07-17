import SwiftUI

enum EmergencyVentilationDilutionModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .emergencyVentilationDilution,
            title: "Emergency Ventilation Dilution",
            subtitle: "Estimate contaminant concentration decay",
            category: .processSafetyAndEconomics,
            symbolName: "fan.fill",
            keywords: [
                "emergency ventilation",
                "dilution",
                "air changes per hour",
                "contaminant decay",
                "well mixed room"
            ]
        ),
        destination: {
            EmergencyVentilationDilutionView()
        }
    )
}
