import SwiftUI

enum AdsorbentMassRequirementModule {
    static let module =
        AppModule(
            metadata:
                ModuleMetadata(
                    id:
                        .adsorbentMassRequirement,
                    title:
                        "Adsorbent Mass Requirement",
                    subtitle:
                        "Size adsorbent inventory from working capacity and cycle time",
                    category: .separationProcesses,
                    symbolName:
                        "shippingbox.circle.fill",
                    keywords: [
                        "adsorbent mass",
                "working capacity",
                "adsorption cycle",
                "solute loading",
                "bed sizing"
                    ]
                ),
            destination: {
                AdsorbentMassRequirementView()
            }
        )
}
