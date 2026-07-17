import SwiftUI

enum VolumetricMassFlowConversionModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .volumetricMassFlowConversion,
            title: "Volumetric Flow–Mass Flow",
            subtitle: "Convert flow rate using density",
            category: .engineeringFundamentals,
            symbolName: "drop.circle.fill",
            keywords: [
                "volumetric flow",
                "mass flow",
                "density",
                "liters per second",
                "flow conversion"
            ]
        ),
        destination: {
            VolumetricMassFlowConversionView()
        }
    )
}
