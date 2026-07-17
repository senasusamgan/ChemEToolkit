import SwiftUI

enum MassFlowMolarFlowConversionModule {
    static let module = AppModule(
        metadata: ModuleMetadata(
            id: .massFlowMolarFlowConversion,
            title: "Mass Flow–Molar Flow",
            subtitle: "Convert flow rate using molecular weight",
            category: .engineeringFundamentals,
            symbolName: "arrow.left.arrow.right.circle.fill",
            keywords: [
                "mass flow",
                "molar flow",
                "molecular weight",
                "kmol per hour",
                "flow conversion"
            ]
        ),
        destination: {
            MassFlowMolarFlowConversionView()
        }
    )
}
