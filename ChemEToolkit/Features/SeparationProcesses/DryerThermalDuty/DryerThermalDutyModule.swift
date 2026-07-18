import SwiftUI

enum DryerThermalDutyModule {
    static let module =
        AppModule(
            metadata:
                ModuleMetadata(
                    id:
                        .dryerThermalDuty,
                    title:
                        "Dryer Thermal Duty",
                    subtitle:
                        "Estimate latent and sensible heat demand for drying",
                    category: .separationProcesses,
                    symbolName:
                        "flame.circle.fill",
                    keywords: [
                        "dryer duty",
                "latent heat",
                "moisture removal",
                "thermal energy",
                "drying"
                    ]
                ),
            destination: {
                DryerThermalDutyView()
            }
        )
}
